//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 22.02.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private var splashScreenLogoImageView: UIImageView?
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var isFirstCall = true
    private let profileService = ProfileService.shared
    private var alertConrtoller: AlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        addSubview()
        makeConstraints()
        alertConrtoller = AlertController(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstCall {
            isFirstCall = false
            if let token = oauth2TokenStorage.token {
                fetchProfile(token)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
                authViewController.delegate = self
                authViewController.modalPresentationStyle = .fullScreen
                present(authViewController, animated: true)
            }
        }
    }
    
    private func configureView() {
        let splashScreenLogoImage = UIImage(named: "launch_screen_logo")
        let splashScreenLogoImageView = UIImageView(image: splashScreenLogoImage)
        splashScreenLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        splashScreenLogoImageView.contentMode = .scaleAspectFit
        self.splashScreenLogoImageView = splashScreenLogoImageView
    }
    
    private func addSubview() {
        view.addSubview(splashScreenLogoImageView ?? UIImageView())
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            splashScreenLogoImageView!.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            splashScreenLogoImageView!.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")}
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let authToken):
                    self.oauth2TokenStorage.token = authToken
                    self.fetchProfile(authToken)
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    self.alertConrtoller?.show()
                    print(error)
                }
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token: token) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let profile):
                    ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    self.alertConrtoller?.show()
                    print(error)
                }
            }
        }
    }
}
