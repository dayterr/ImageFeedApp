//
//  ImagesListViewPresenter.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 11.11.2023.
//

import Foundation

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func getPhotoURL(photo: Photo) -> URL?
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol?
    private let imagesListService = ImagesListService()
    private var imagesListServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        changeNotification()
    }
    
    func changeNotification() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
                guard let self else { return }
                self.view?.updateTableViewAnimated()
        }
    }
    
    func getPhotoURL(photo: Photo) -> URL? {
        let photoUrl = photo.thumbImageURL
        guard let url = URL(string: photoUrl) else { return nil }
        return url
    }
}
