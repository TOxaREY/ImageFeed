//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 02.02.2023.
//

import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var logoutButton: UIButton?
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var alertProvider: AlertTwoButtonProvider?
    private var animationLayers = Set<CALayer>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        configureView()
        addSubview()
        makeConstraints()
        updateProfileDatails(profile: profileService.profile!)
        gradientAvatar()
        gradientLabel(label: nameLabel!, width: 225, height: 25, key: "nameLabel")
        gradientLabel(label: loginNameLabel!, width: 90, height: 18, key: "loginLabel")
        gradientLabel(label: descriptionLabel!, width: 70, height: 15, key: "descripLabel")
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        alertProvider = AlertTwoButtonProvider(viewController: self)
        updateAvatar()
    }
    
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { record in
            record.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) {}
            }
        }
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarUrl,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        avatarImageView?.kf.setImage(with: url,
                                     placeholder: UIImage(named: "avatar_placeholder"),
                                     options: [.cacheSerializer(FormatIndicatedCacheSerializer.png),
                                               .processor(processor)])
        removeGradients()
    }
    
    private func configureView() {
        let avatarImage = UIImage(named: "avatar_placeholder")
        let avatarImageView = UIImageView(image: avatarImage)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFit
        self.avatarImageView = avatarImageView
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel = nameLabel
        
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = UIColor(named: "YP Gray")
        loginNameLabel.textAlignment = .left
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.loginNameLabel = loginNameLabel
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel = descriptionLabel
        
        let logoutButton = UIButton.systemButton(
                    with: UIImage(named: "ipad_and_arrow_forward")!,
                    target: self,
                    action: #selector(Self.didTapLogoutButton)
                )
        logoutButton.tintColor = UIColor(named: "YP Red")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        self.logoutButton = logoutButton
    }
    
    private func addSubview() {
        view.addSubview(avatarImageView ?? UIImageView())
        view.addSubview(nameLabel ?? UILabel())
        view.addSubview(loginNameLabel ?? UILabel())
        view.addSubview(descriptionLabel ?? UILabel())
        view.addSubview(logoutButton ?? UIButton())
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView!.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView!.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel!.topAnchor.constraint(equalTo: self.avatarImageView!.bottomAnchor, constant: 8),
            nameLabel!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel!.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            loginNameLabel!.topAnchor.constraint(equalTo: self.nameLabel!.bottomAnchor, constant: 8),
            loginNameLabel!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginNameLabel!.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            descriptionLabel!.topAnchor.constraint(equalTo: self.loginNameLabel!.bottomAnchor, constant: 8),
            descriptionLabel!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel!.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            logoutButton!.widthAnchor.constraint(equalToConstant: 24),
            logoutButton!.heightAnchor.constraint(equalToConstant: 24),
            logoutButton!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            logoutButton!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func updateProfileDatails(profile: Profile) {
        nameLabel?.text = profile.name
        loginNameLabel?.text = profile.loginName
        descriptionLabel?.text = profile.bio
    }
    
    private func segueSplashViewController() {
        let splashViewController = SplashViewController()
        splashViewController.modalPresentationStyle = .fullScreen
        present(splashViewController, animated: true)
    }
    
    private func logoutAction() {
        oauth2TokenStorage.removeToken()
        ProfileViewController.clean()
        segueSplashViewController()
    }
    
    private func gradientAvatar() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: 70, height: 70))
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 35
        gradient.masksToBounds = true
        avatarImageView?.layer.addSublayer(gradient)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChangeAvatar")
        animationLayers.insert(gradient)
    }
    
    private func gradientLabel(label: UILabel, width: CGFloat, height: CGFloat, key: String) {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.cornerRadius = 9
        gradient.masksToBounds = true
        label.layer.addSublayer(gradient)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: key)
        animationLayers.insert(gradient)
    }
    
    private func removeGradients() {
        for grad in animationLayers {
            grad.removeFromSuperlayer()
        }
    }
    
    @objc private func didTapLogoutButton() {
        alertProvider?.show(title: "Пока, пока!",
                            message: "Уверены что хотите выйти?",
                            yesButtonTitle: "Да",
                            noButtonTitle: "Нет",
                            action: logoutAction)
    }
}
