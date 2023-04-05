//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Anton Reynikov on 21.03.2023.
//

import Foundation

fileprivate let unsplashListPhotosString = "https://api.unsplash.com/photos?page="
fileprivate let unsplashLikeUnlikePhotoString = "https://api.unsplash.com/photos/"

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
        
        let task = urlsSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                for photo in body {
                    self.photos.append(Photo(id: photo.id, size: CGSize(width: photo.width, height: photo.height), createdAt: photo.createdAt, welcomeDescription: photo.description, thumbImageURL: photo.urls.thumb, largeImageURL: photo.urls.full, isLiked: photo.likedByUser))
                }
                self.lastLoadedPage = nextPage
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self)
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        var request = URLRequest(url: URL(string: unsplashLikeUnlikePhotoString + photoId + "/like")!)
        if isLike {
            request.httpMethod = "POST"
            request.setValue("Bearer \(oauth2TokenStorage.token!))", forHTTPHeaderField: "Authorization")
        } else {
            request.httpMethod = "DELETE"
            request.setValue("Bearer \(oauth2TokenStorage.token!))", forHTTPHeaderField: "Authorization")
        }
        
        let task = urlsSession.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode >= 300 {
                    completion(.failure(NetworkError.codeError))
                    return
                }
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        isLiked: !photo.isLiked
                    )
                    self.photos[index] = newPhoto
                }
                completion(.success(()))
            }
        })
        task.resume()
    }
}
