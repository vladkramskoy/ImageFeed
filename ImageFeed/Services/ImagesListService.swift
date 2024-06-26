import Foundation
import SwiftKeychainWrapper

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let dateFormatter = ISO8601DateFormatter()
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard task == nil else {
            debugPrint("Error ImageListService [fetchPhotosNextPage]: Race Condition - reject repeated photos request")
            return
        }
        
        let path = "/photos?page=\(nextPage)"
        guard let url = URL(string: path, relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Error ImageListService [URL]: Failed to create URL")
            return
        }
        
        var request = URLRequest(url: url)
        guard let token: String = KeychainWrapper.standard.string(forKey: "Auth token") else {
            print("Error ProfileImageService [KeychainWrapper.standard.string]: Failed to get value from Keychain")
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let responce):
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: self.convertPhotoResultsToPhoto(results: responce))
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                }
                
                lastLoadedPage = (lastLoadedPage ?? 0) + 1
                
                self.task = nil
            case .failure(let error):
                print("Error ImageListService [objectTask]: \(error.localizedDescription)")
            }
        }
        self.task = task
        task.resume()
    }
    
    private func convertPhotoResultsToPhoto(results: [PhotoResult]) -> [Photo] {
        
        return results.map { photoResult in
            let thumbWidth = 200.0
            let aspectRatio = Double(photoResult.width) / Double(photoResult.height)
            let thumbHeight = thumbWidth / aspectRatio
            let size = CGSize(width: photoResult.width, height: photoResult.height)
            let createdDate = photoResult.createdAt.flatMap { ImagesListService.dateFormatter.date(from: $0) }
            
            let photo = Photo(id: photoResult.id,
                              size: size,
                              created: createdDate,
                              welcomeDescription: photoResult.altDescription,
                              thumbImageURL: photoResult.urls.thumb,
                              largeImageURL: photoResult.urls.raw,
                              isLiked: photoResult.likedByUser,
                              thumbSize: CGSize(width: thumbWidth, height: thumbHeight))
            return photo
        }
    }
    
    func changeLike(photoID: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let method = isLike ? "DELETE" : "POST"
        
        if task != nil {
            task?.cancel()
        }
        
        let path = "/photos/\(photoID)/like"
        guard let url = URL(string: path, relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Error ImageListService [URL]: Failed to create URL")
            return
        }
        
        var request = URLRequest(url: url)
        guard let token: String = KeychainWrapper.standard.string(forKey: "Auth token") else {
            print("Error ProfileImageService [KeychainWrapper.standard.string]: Failed to get value from Keychain")
            return
        }
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { [weak self] data, responce, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error ImagesListService [dataTask]: \(error)")
                completion(.failure(error))
            }
            
            if let index = self.photos.firstIndex(where: { $0.id == photoID }) {
                let photo = photos[index]
                
                let newPhoto = Photo(id: photo.id,
                                     size: photo.size,
                                     created: photo.created,
                                     welcomeDescription: photo.welcomeDescription,
                                     thumbImageURL: photo.thumbImageURL,
                                     largeImageURL: photo.largeImageURL,
                                     isLiked: !photo.isLiked,
                                     thumbSize: photo.thumbSize)
                self.photos[index] = newPhoto
            }
            completion(.success(()))
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func resetPhotos() {
        self.photos = []
    }
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let altDescription: String?
    let urls: UrlResult
    let likedByUser: Bool
}

struct UrlResult: Decodable {
    let raw: String
    let thumb: String
}

struct Photo: Decodable {
    let id: String
    let size: CGSize
    let created: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    let thumbSize: CGSize
}
