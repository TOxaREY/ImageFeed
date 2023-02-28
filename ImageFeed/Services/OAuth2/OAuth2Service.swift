//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 22.02.2023.
//

import Foundation

fileprivate let unsplashOAuthTokenURL = URL(string: "https://unsplash.com/oauth/token")!

final class OAuth2Service {
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Swift.Result<String, Error>) -> Void) {
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
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetworkError.codeError))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let authTokenBody = try decoder.decode(AuthTokenResponseBody.self, from: data)
                completion(.success(authTokenBody.accessToken))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
