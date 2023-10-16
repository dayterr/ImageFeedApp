//
//  TabBarController.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 15.10.2023.
//

import UIKit
 
final class TabBarController: UITabBarController {
    private let imagesListViewControllerIdentifier = "ImagesListViewController"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: imagesListViewControllerIdentifier)
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tabProfileActive"),
            selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }

}
