import Foundation

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    static let shared = ProfileService()
    
    private var task: URLSessionDataTask?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        if task != nil {
            task?.cancel()
        }
        
        let path = "/me"
        guard let url = URL(string: path, relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Failed to create URL")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            
            if let error = error {
                print("Error: \(error)")
                completion(.failure(ProfileServiceError.invalidRequest))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(ProfileServiceError.invalidRequest))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let personResult = try decoder.decode(ProfileResult.self, from: data)
                let person = Profile(username: personResult.username, name: personResult.firstName + " " + (personResult.lastName ?? ""), loginName: "@\(personResult.username)", bio: personResult.bio)
                completion(.success(person))
                self?.task = nil
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private init() {}
}

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}
