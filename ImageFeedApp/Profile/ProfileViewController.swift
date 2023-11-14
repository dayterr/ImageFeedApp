//
//  ProfileViewController.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 09.07.2023.
//

import Kingfisher
import UIKit
import WebKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateAvatar()
    func updateProfile(profile: Profile?)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol? 
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let oAuth2TokenStorage = OAuth2TokenStorage()

    
    private let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "userpick")
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        return profileImage
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .ypWhite
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private let emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.text = "@ekaterina.nov"
        emailLabel.font = .systemFont(ofSize: 13, weight: .regular)
        emailLabel.textColor = .ypGray
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        return emailLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private var logoutButton: UIButton = UIButton.systemButton(with: UIImage(imageLiteralResourceName: "logout_button"), target: self, action: #selector(Self.didTapLogautButton))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.accessibilityIdentifier = "logout_button"
        logoutButton.setImage(UIImage(named: "logout_button"), for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.tintColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        view.backgroundColor = .ypBlack
        
        addSubViews()
        applyConstraints()
        
        presenter = ProfileViewPresenter()
        presenter?.view = self
        presenter?.viewDidLoad()
        
    }
    
    @objc private func didTapLogautButton() {
        logOut()
    }
    
    func updateAvatar() {                                   // 8
        print("updating")
        let url = presenter?.getAvatarURL()
        print(url)
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: url,
                              placeholder: UIImage(named: "userpick"),
                              options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
        
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
    }
    
    private func addSubViews() {
        view.addSubview(profileImage)
        view.addSubview(nameLabel)
        view.addSubview(logoutButton)
        view.addSubview(emailLabel)
        view.addSubview(descriptionLabel)
    }
    
    func updateProfile(profile: Profile?) {
        updateAvatar()
        
        guard let profile = profile else { return }
        nameLabel.text = profile.name
        emailLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func logOut() {
        UIBlockingProgressHUD.dismiss()
        
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Да", style: .default) { _ in
            self.presenter?.logOut()
        })
        
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -124),
        ])
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
        ])
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -260),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -282),
        ])
    }

}
