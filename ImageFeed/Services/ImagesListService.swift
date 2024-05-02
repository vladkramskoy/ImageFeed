import Foundation
import SwiftKeychainWrapper

final class ImageListService {
    static let shared = ImageListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage ?? 0) + 1
        if task != nil {
            task?.cancel()
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
                }
                
                if let currentPage = lastLoadedPage {
                    self.lastLoadedPage = currentPage + 1
                } else {
                    self.lastLoadedPage = 1
                }
                
                print("Next Page: \(nextPage)") // DEL
                print(url.absoluteString) // DEL
                print(self.photos) // DEL
            case .failure(let error):
                print("Error ImageListService [objectTask]: \(error.localizedDescription)")
            }
        }
        self.task = task
        task.resume()
    }
    
    private func convertPhotoResultsToPhoto(results: [PhotoResult]) -> [Photo] {
        let dateFormatter = ISO8601DateFormatter()
        
        return results.map { photoResult in
            let size = CGSize(width: photoResult.width, height: photoResult.height)
            let createdDate = photoResult.createdAt != nil ? dateFormatter.date(from: photoResult.createdAt ?? "") : nil
            let photo = Photo(id: photoResult.id,
                              size: size,
                              created: createdDate,
                              welcomeDescription: photoResult.altDescription,
                              thumbImageURL: photoResult.urls.thumb,
                              largeImageURL: photoResult.urls.raw,
                              isLiked: photoResult.likedByUser)
            return photo
        }
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

struct Photo: Decodable { // структура для UI
    let id: String
    let size: CGSize
    let created: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
