//
//  OAuth2TokenStorage.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 20.07.2023.
//

import Foundation

final class OAuth2TokenStorage {
    let tokenKey = "newAuthToken"
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            userDefaults.string(forKey: tokenKey)
        }
        set {
            if let name = newValue {
                userDefaults.set(name, forKey: tokenKey)
            }
        }
    }
}
