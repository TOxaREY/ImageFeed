//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 22.02.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            return userDefaults.string(forKey: "bearerToken")
        }
        set (newToken){
            userDefaults.set(newToken, forKey: "bearerToken")
        }
    }
}
