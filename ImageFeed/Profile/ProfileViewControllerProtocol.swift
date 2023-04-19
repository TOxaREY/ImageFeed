//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 11.04.2023.
//

import Foundation
import UIKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    var avatarImageView: UIImageView? { get set }
    func configureViews()
    func addSubviews()
    func makeConstraints()
    func logoutAction()
    func updateProfileDetails(profile: Profile)
    func configure(_ presenter: ProfilePresenterProtocol)
}
