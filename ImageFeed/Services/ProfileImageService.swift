import Foundation
import SwiftKeychainWrapper

enum ProfileImageServiceError: Error {
    case invalidRequest
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        let path = "/users/\(username)"
        guard let url = URL(string: path, relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Error ProfileImageService [URL]: Failed to create URL")
            completion(.failure(ProfileImageServiceError.invalidRequest))
            return
        }
        
        var request = URLRequest(url: url)
        guard let token: String = KeychainWrapper.standard.string(forKey: "Auth token") else {
            print("Error ProfileImageService [KeychainWrapper.standard.string]: Failed to get value from Keychain")
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let decodedData):
                self.avatarURL = decodedData.profileImage.small
                guard let profileImageURL = self.avatarURL else { return }
                completion(.success(profileImageURL))
                
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": decodedData])
                
                self.task = nil
            case .failure(let error):
                print("Error ProfileImageService [URL]: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    struct ProfileImage: Codable {
        let small: String
    }
}
