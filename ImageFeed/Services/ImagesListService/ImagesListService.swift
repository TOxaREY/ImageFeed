//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 21.03.2023.
//

import Foundation

fileprivate let unsplashListPhotosString = "https://api.unsplash.com/photos?page="

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private let urlsSession = URLSession.shared
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        task?.cancel()
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        var request = URLRequest(url: URL(string: unsplashListPhotosString + String(nextPage))!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(oauth2TokenStorage.token!))", forHTTPHeaderField: "Authorization")
        
        let task = urlsSession.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            switch result {
            case .success(let body):
                self?.photos.append(Photo(id: body.id, size: CGSize(width: body.width, height: body.height), createdAt: body.createdAt, welcomeDescription: body.description, thumbImageURL: body.urls.thumb, largeImageURL: body.urls.full, isLiked: body.likedByUser))
                self?.lastLoadedPage! += 1
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self)
            case .failure(let error):
                print(error)
            }
            self?.task = nil
        }
        self.task = task
        task.resume()
    }
}
