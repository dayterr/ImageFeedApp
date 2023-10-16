//
//  ProfileService.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 27.09.2023.
//

import Foundation

struct Profile {
    let username: String
    let name: String?
    let loginName: String
    let bio: String?
}

struct ProfileBody: Decodable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

final class ProfileService {
    
    static let shared = ProfileService()
    
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private (set) var profile: Profile?
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            task?.cancel()
        }
        
        var requestURL: URL {
            guard let requestURL = URL(string: "/me", relativeTo: DefaultBaseURL) else {
                preconditionFailure("Failed to build URL")
            }
            return requestURL
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileBody, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let profile = Profile(username: body.username, name: "\(body.firstName ?? "") \(body.lastName ?? "")", loginName: "@\(body.username)", bio: body.bio ?? "")
                    self.profile = profile
                    completion(.success(profile))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.task = nil
                }
                
            }
            
        }
    }
}

