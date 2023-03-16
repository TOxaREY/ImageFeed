//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 14.03.2023.
//

import Foundation

fileprivate let unsplashPublicProfileString = "https://api.unsplash.com/users/"

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private(set) var avatarUrl: String?
    
    private let urlsSession = URLSession.shared
    private var task: URLSessionTask?
    
    private init() { }
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        var request = URLRequest(url: URL(string: unsplashPublicProfileString + username)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(oauth2TokenStorage.token!))", forHTTPHeaderField: "Authorization")
        
        let task = urlsSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let body):
                self?.avatarUrl = body.profileImage.small
                completion(.success((self?.avatarUrl)!))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self?.avatarUrl! as Any])
            case .failure(let error):
                completion(.failure(error))
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
}
