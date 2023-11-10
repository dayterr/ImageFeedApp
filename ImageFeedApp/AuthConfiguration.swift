//
//  Constants.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 17.07.2023.
//

import Foundation

let AccessKey = "rQQC1XoNd0KDMAIjwsOZO1QzxwC4uxd5U9upvCuORSA"
let SecretKey = "ZeW15VEB9oyeM8PSr4gg1Teqg5zlVeEt_uJTlbaWkzI"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: AccessKey,
            secretKey: SecretKey,
            redirectURI: RedirectURI,
            accessScope: AccessScope,
            authURLString: UnsplashAuthorizeURLString,
            defaultBaseURL: DefaultBaseURL
        )
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}