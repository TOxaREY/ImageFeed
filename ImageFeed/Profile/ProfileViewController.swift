//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 02.02.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var logoutButton: UIButton?
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        configureView()
        addSubview()
        makeConstraints()
        updateProfileDatails(profile: profileService.profile!)
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
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
    
    @objc private func didTapLogoutButton() {
        
    }
}
