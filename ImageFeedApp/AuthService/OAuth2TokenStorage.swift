//
//  OAuth2TokenStorage.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 20.07.2023.
//

import Foundation

final class OAuth2TokenStorage {
    let tokenKey = "BearerToken"
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
}
