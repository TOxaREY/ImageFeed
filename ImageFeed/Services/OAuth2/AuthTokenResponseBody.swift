//
//  AuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 22.02.2023.
//

import Foundation

struct AuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
