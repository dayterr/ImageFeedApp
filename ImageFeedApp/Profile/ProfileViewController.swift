//
//  ProfileViewController.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 09.07.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var profileImage = UIImageView()
    private var logoutButton = UIButton()
    private var nameLabel = UILabel()
    private var emailLabel = UILabel()
    private var descriptionLabel = UILabel()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            loadProfile()
    }
    
    private func loadProfile() {
        view.backgroundColor = .ypBlack
        loadProfileImage()
        loadLogoutButton()
        loadNameLabel()
        loadEmail()
        loadDescription()
    }
    
    private func loadProfileImage() {
        view.addSubview(profileImage)
        
        profileImage.image = UIImage(named: "userpick")
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func loadLogoutButton() {
        view.addSubview(logoutButton)
            
        logoutButton.setImage(UIImage(named: "logout_button"), for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
        ])
    }
    
    private func loadNameLabel() {
        view.addSubview(nameLabel)
            
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .ypWhite
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -124),
        ])
    }
    
    private func loadEmail() {
        view.addSubview(emailLabel)
        
        emailLabel.text = "@ekaterina.nov"
        emailLabel.font = .systemFont(ofSize: 13, weight: .regular)
        emailLabel.textColor = .ypGray
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -260),
            ])
    }
    
    private func loadDescription() {
        view.addSubview(descriptionLabel)
        
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -282),
        ])
    }
}
