//
//  ViewController.swift
//  ImageFeedApp
//
//  Created by Ruth Dayter on 28.04.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    private var ShowSingleImageSegueIdentifier = "ShowSingleImage"

    @IBOutlet private var tableView: UITableView!
    
    private let imagesListService = ImagesListService()
    private var imagesListServiceObserver: NSObjectProtocol?
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesListService.fetchPhotosNextPage()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        changeNotification()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let singleImageURL = imagesListService.photos[indexPath.row].largeImageURL
            viewController.singleImageURL = singleImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private lazy var isoDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    func convertDate(dateValue: String) -> Date? {
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from: dateValue)
            if let date = date {
                return date
            } else {
                return nil
            }
        }
    

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = imagesListService.photos[indexPath.row]
        let photoUrl = photo.thumbImageURL
        guard let url = URL(string: photoUrl) else { return }
                
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.contentMode = .center
        cell.isUserInteractionEnabled = false
        cell.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "stub_image")) { result in
            switch result {
            case .success:
                cell.cellImage.contentMode = .scaleAspectFill
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            case .failure(let error):
                print("Не удалось загрузить фотографию \(error)")
                
            }
            cell.isUserInteractionEnabled = true
        }
         
        guard let createdAt = photo.createdAt else { cell.dateLabel.text = ""; return }
        if convertDate(dateValue: createdAt) != nil {
            let date = dateFormatter.date(from: createdAt)
            if let date = date {
                cell.dateLabel.text = dateFormatter.string(from: date)
            }
        }
        
        setIsLiked(photo, cell)
    }
    
    private func setIsLiked(_ photo: Photo, _ cell: ImagesListCell) {
        let buttonState = photo.isLiked ? "like_button_on" : "like_button_off"
        cell.likeButton.setImage(UIImage(named: buttonState), for: .normal)
    }
    
    private func changeNotification() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
                guard let self else { return }
                self.updateTableViewAnimated()
            }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPath = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < imagesListService.photos.count else { return 0 }
        
        let imageSize = imagesListService.photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        let imageWidth = imageSize.width
        if imageWidth == 0 { return 0 }
        
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
                
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        return imageListCell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { result in
            switch result {
            case .success:
                self.photos[indexPath.row].isLiked = self.imagesListService.photos[indexPath.row].isLiked
                self.setIsLiked(self.photos[indexPath.row], cell)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("Ошибка: \(error)")
            }
        }
    }
}
