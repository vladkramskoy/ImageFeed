import Foundation

enum ProfileImageServiceError: Error {
    case invalidRequest
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private var task: URLSessionDataTask?
    private (set) var avatarURL: String?
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        let path = "/users/\(username)"
        guard let url = URL(string: path, relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Failed to create URL")
            completion(.failure(ProfileImageServiceError.invalidRequest))
            return
        }
        
        var request = URLRequest(url: url)
        guard let token = OAuth2TokenStorage.shared.token else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { [weak self] (data, responce, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error)")
                completion(.failure(ProfileImageServiceError.invalidRequest))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(ProfileImageServiceError.invalidRequest))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let profileImageResult = try decoder.decode(UserResult.self, from: data)
                self.avatarURL = profileImageResult.profileImage.small
                guard let profileImageURL = self.avatarURL else { return }
                completion(.success(profileImageURL))
                
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": profileImageURL])
                
                self.task = nil
            } catch {
                print(error.localizedDescription)
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
