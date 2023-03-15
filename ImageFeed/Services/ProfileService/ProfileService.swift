//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 13.03.2023.
//

import Foundation

fileprivate let unsplashProfileURL = URL(string: "https://api.unsplash.com/me")!

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?

    private let urlsSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        var request = URLRequest(url: unsplashProfileURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlsSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let body):
                self?.profile = Profile(username: body.username, name: "\(body.firstName) \(body.lastName)", loginName: "@\(body.username)", bio: body.bio)
                completion(.success((self?.profile)!))
            case .failure(let error):
                completion(.failure(error))
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
}

