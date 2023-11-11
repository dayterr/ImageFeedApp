//
//  ProfileViewPresenter.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 11.11.2023.
//

import Foundation
import UIKit
import Kingfisher
import WebKit

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func getAvatarURL() -> URL?
    func logOut()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {

    weak var view: ProfileViewControllerProtocol?
    var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    func viewDidLoad() {
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main                                        // 5
        ) { [weak self] _ in
            guard let self = self else { return }
            self.getAvatarURL()                                // 6
        }
        view?.updateProfile(profile: profileService.profile)
    }
    
    func getAvatarURL() -> URL? {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        return url
    }
    
    internal func logOut() {
        self.oAuth2TokenStorage.removeToken()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
           WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
              records.forEach { record in
                 WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
              }
           }
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
}
