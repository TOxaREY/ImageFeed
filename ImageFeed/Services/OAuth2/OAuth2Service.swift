//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 22.02.2023.
//

import Foundation

fileprivate let unsplashOAuthTokenURL = URL(string: "https://unsplash.com/oauth/token")!

final class OAuth2Service {
    
    private let urlsSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(code: String, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        var request = URLRequest(url: unsplashOAuthTokenURL)
        request.httpMethod = "POST"
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "client_secret", value: secretKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        request.httpBody = urlComponents.percentEncodedQuery?.data(using: .utf8)
        
        let task = urlsSession.objectTask(for: request) { [weak self] (result: Result<AuthTokenResponseBody, Error>) in
            switch result {
            case .success(let body):
                completion(.success(body.accessToken))
            case .failure(let error):
                self?.lastCode = nil
                completion(.failure(error))
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
}
