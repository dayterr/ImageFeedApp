//
//  OAuth2TokenStorage.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 20.07.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    let tokenKey = "BearerToken"
    private let userStorage = KeychainWrapper.standard
    
    var token: String? {
        get {
            let token = userStorage.string(forKey: tokenKey)
            guard let token = token else { return nil }
            return token
        }
        set {
            guard let newValue = newValue else { return }
            userStorage.set(newValue, forKey: tokenKey)
        }
    }
}
