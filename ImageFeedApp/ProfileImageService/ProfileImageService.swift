//
//  ProfileImageService.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 08.10.2023.
//

import Foundation

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

final class ProfileImageService {
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    static let shared = ProfileImageService()
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private (set) var avatarURL: String?
 
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String?, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            task?.cancel()
        }
        
        let URLString: String = "/users/\(username)"
        
        var requestURL: URL {
            guard let requestURL = URL(string: URLString, relativeTo: DefaultBaseURL) else {
                preconditionFailure("Failed to build URL")
            }
            return requestURL
        }
        
        var requestImage = URLRequest(url: requestURL)
        requestImage.httpMethod = "GET"
        
        let task = urlSession.objectTask(for: requestImage) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let body):
                    self.avatarURL = body.profileImage.small
                    completion(.success(self.avatarURL))
                    NotificationCenter.default.post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": self.avatarURL ?? ""])
                    self.task = nil
                
                case .failure(let error):
                    completion(.failure(error))
                    self.task = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
}

