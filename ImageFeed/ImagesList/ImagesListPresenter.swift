//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 17.04.2023.
//

import Foundation
import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func willDisplay(forRowAt indexPath: IndexPath)
    func heightForRowAt(indexPath: IndexPath) -> CGFloat
    func numberOfRowsInSection() -> Int
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

final class ImagesListPresenter: ImagesListPresenterProtocol, ImagesListCellDelegate {
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    private let imagesListService = ImagesListService()
    private var imagesListServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        view?.tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        addImagesListServiceObserver()
        imagesListService.fetchPhotosNextPage()
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = self
        guard let url = URL(string: photos[indexPath.row].thumbImageURL) else { return }
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url,
                                   placeholder: UIImage(named: "Stab")) { [weak self] _ in
            guard let self = self else { return }
            cell.cellImage.contentMode = .scaleAspectFill
            self.view?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.setIsLiked(photos[indexPath.row].isLiked)
        guard let createdAt = photos[indexPath.row].createdAt else {
            cell.dateLabel.text = ""
            return
        }
        cell.dateLabel.text = dateFormatter.string(from: createdAt)
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = view?.tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                print(error)
                UIBlockingProgressHUD.dismiss()
                self.view?.alertProvider?.show(message: error.localizedDescription)
            }
        }
    }
    
    func addImagesListServiceObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(forName: ImagesListService.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
    
    func willDisplay(forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        let photoInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let photoViewWidth = (view?.tableView.bounds.width)! - photoInsets.left - photoInsets.right
        let photoWidth = photos[indexPath.row].size.width
        let scale = photoViewWidth / photoWidth
        let cellHeight = photos[indexPath.row].size.height * scale + photoInsets.top + photoInsets.bottom
        return cellHeight
    }
    
    func numberOfRowsInSection() -> Int{
        return photos.count
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! SingleImageViewController
        let indexPatch = sender as! IndexPath
        let fullImageURL = URL(string: photos[indexPatch.row].largeImageURL)!
        viewController.fullImageURL = fullImageURL
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                view?.tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}
