//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Anton Reynikov on 11.04.2023.
//

import ImageFeed
import Foundation
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var loadConfigureViews: Bool = false
    var loadAddSubviews: Bool = false
    var loadMakeConstraints: Bool = false
    var loadUpdateProfileDetails: Bool = false
    
    var avatarImageView: UIImageView?
    
    func configure(_ presenter: ImageFeed.ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    func configureViews() {
        loadConfigureViews = true
    }
    
    func addSubviews() {
        loadAddSubviews = true
    }
    
    func makeConstraints() {
        loadMakeConstraints = true
    }
    
    func logoutAction() {
        
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile) {
        loadUpdateProfileDetails = true
    }
}
