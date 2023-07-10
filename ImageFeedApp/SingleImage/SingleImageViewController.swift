//
//  SingleImageViewController.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 10.07.2023.
//

import UIKit

class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }

    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }

}
