//
//  PhotoResult.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 23.10.2023.
//

import Foundation

struct UrlResult: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let urls: UrlResult
    let isLiked: Bool
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case description
        case urls
        case isLiked = "liked_by_user"
    }
    
}
