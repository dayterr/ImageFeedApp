//
//  OAuth2Service.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 20.07.2023.
//

import Foundation

enum NetworkError: Error {
    case codeError
}

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
        case createdAt = "created_at"
    }
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    private var task: URLSessionTask?
    private var lastCode: String?

    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                return
            }
        } else {
            if lastCode == code {
                return
            }
        }
        
        let URLString: String = "/oauth/token" +
            "?client_id=\(AccessKey)" +
            "&client_secret=\(SecretKey)" +
            "&redirect_uri=\(RedirectURI)" +
            "&code=\(code)" +
            "&grant_type=authorization_code"
        
        var requestURL: URL {
            guard let requestURL = URL(string: URLString, relativeTo: DefaultBaseURL) else {
                preconditionFailure("Failed to build URL")
            }
            return requestURL
        }
        
        lastCode = code

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    self.task = nil
                    completion(.success(authToken))
                    
                case .failure(let error):
                    self.lastCode = nil
                    completion(.failure(error))
                }
            }
        }
        
        self.task = task
        task.resume()
    }
}

