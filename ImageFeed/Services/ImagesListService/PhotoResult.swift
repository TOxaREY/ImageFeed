//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 21.03.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: Date
    let width: Int
    let height: Int
    let description: String
    let urls: UrlsResult
    let likedByUser: Bool
}

struct UrlsResult: Codable {
    let full: String
    let thumb: String
}
