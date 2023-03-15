//
//  UserResult.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 14.03.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ImageSize
}

struct ImageSize: Codable {
    let small: String
}
