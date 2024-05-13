import Foundation

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    static let shared = ProfileService()
    
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        let path = "/me"
        guard let url = URL(string: path, relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Error ProfileService [URL]: Failed to create URL")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }

            switch result {
            case .success(let decodedData):
                let profile = Profile(username: decodedData.username, firstName: decodedData.firstName, lastName: decodedData.lastName, loginName: "@\(decodedData.username)", bio: decodedData.bio)
                self.profile = profile
                completion(.success(profile))
                self.task = nil
            case .failure(let error):
                print("Error ProfileService [objectTask]: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func resetProfile() {
        self.profile = nil
    }
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}

struct Profile {
    let username: String
    let firstName: String
    let lastName: String?
    let loginName: String
    let bio: String?
    
    var name: String { firstName + " " + (lastName ?? "") }
}
