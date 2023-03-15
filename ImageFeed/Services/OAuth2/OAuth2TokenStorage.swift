//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 22.02.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "bearerToken")
        }
        set (newToken){
            let isSuccess = KeychainWrapper.standard.set(newToken!, forKey: "bearerToken")
            guard isSuccess else {
                print("неудалось сохранить токен")
                return
            }
        }
    }
}
