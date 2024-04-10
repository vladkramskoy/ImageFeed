import Foundation

class OAuth2Service {
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            print("Invalid base URL")
            return nil
        }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            print("Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
    
    func fetchOAuthToken(code: String) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            return
        }
        
        let task = URLSession.shared.data(for: request) { result in // Ответ у POST запроса будет обработан этим методом
            switch result {
            case .success(let data):
                print("OK. Токен доступа получен", data)
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    print(response)
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("FAIL. Токен доступа не был получен", error)
            }
        }
        task.resume()
    }
}
