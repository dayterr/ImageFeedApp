//
//  ImagesListService.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 23.10.2023.
//

import Foundation

final class ImagesListService {
    private (set) var photos: [Photo] = []
    static let DidChangeNotification = Notification.Name(
        rawValue: "ImagesListServiceDidChange"
    )
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    private var pageTask: URLSessionTask?
    private var likeTask: URLSessionTask?

    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        if pageTask != nil {
            pageTask?.cancel()
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        var imagesListURL: URL {
            guard let imagesListURL = URL(
                string: "/photos?page=\(nextPage)&&per_page=10",
                relativeTo: DefaultBaseURL
            ) else {
                preconditionFailure("Failed to build URL")
            }
            return imagesListURL
        }

        var request = URLRequest(url: imagesListURL)
        request.httpMethod = "GET"
        
        var authToken: String {
            guard let authToken = OAuth2TokenStorage().token else {
                return ""
            }
            return authToken
        }

        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    self.photos += body.map {
                        Photo(id: $0.id,
                              size: CGSize(width: $0.width, height: $0.height),
                              createdAt: $0.createdAt,
                              welcomeDescription: $0.description,
                              thumbImageURL: $0.urls.thumb ?? "",
                              largeImageURL: $0.urls.full ?? "",
                              isLiked: $0.isLiked)
                    }
                    NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self, userInfo: ["photos": self.photos])
                    print("Запрос совершен")
                    self.lastLoadedPage = nextPage
                    self.pageTask = nil
                    
                case .failure(let error):
                    print("Ошибка загрузки фото \(error)")
                    self.pageTask = nil
                }
            }
        }
        
        self.pageTask = nil
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        likeTask?.cancel()
        let httpMethod = isLike ? "DELETE" : "POST"
        
        var likeURL: URL {
            guard let likeURL = URL(
                string: "photos/\(photoId)/like",
                relativeTo: DefaultBaseURL
            ) else {
                preconditionFailure("Failed to build URL")
            }
            return likeURL
        }
        
        var likeRequest = URLRequest(url: likeURL)
        likeRequest.httpMethod = httpMethod
        
        var authToken: String {
            guard let authToken = OAuth2TokenStorage().token else {
                return ""
            }
            return authToken
        }

        likeRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let likeTask = urlSession.objectTask(for: likeRequest) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let likeResult):
                    let photoId = likeResult.photo.id
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        self.photos[index].isLiked = likeResult.photo.isLiked
                    }
                    completion(.success(()))
                    self.likeTask = nil
                    
                case .failure(let error):
                    completion(.failure(error))
                    self.likeTask = nil
                }
            }
        }
        self.likeTask = likeTask
        likeTask.resume()
    }
}
