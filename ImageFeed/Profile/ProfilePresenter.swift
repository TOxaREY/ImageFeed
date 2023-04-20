//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 11.04.2023.
//

import Foundation
import UIKit
import Kingfisher
import WebKit

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func logoutAction(viewController: UIViewController)
    func viewDidLoad()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    func viewDidLoad() {
        view?.configureViews()
        view?.addSubviews()
        view?.makeConstraints()
        view?.updateProfileDetails(profile: profile)
        addProfileImageServiceObserver()
        updateAvatar()
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarUrl,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        view?.avatarImageView?.kf.setImage(with: url,
                                     placeholder: UIImage(named: "avatar_placeholder"),
                                     options: [.cacheSerializer(FormatIndicatedCacheSerializer.png),
                                               .processor(processor)])
    }
    
    func logoutAction(viewController: UIViewController) {
        oauth2TokenStorage.removeToken()
        ProfilePresenter.clean()
        segueSplashViewController(viewController: viewController)
    }
    
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { record in
            record.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) {}
            }
        }
    }
    
    func addProfileImageServiceObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    private func segueSplashViewController(viewController: UIViewController) {
        let splashViewController = SplashViewController()
        splashViewController.modalPresentationStyle = .fullScreen
        viewController.present(splashViewController, animated: true)
    }
}
