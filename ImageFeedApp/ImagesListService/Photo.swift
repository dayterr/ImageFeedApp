//
//  Photo.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 23.10.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}
