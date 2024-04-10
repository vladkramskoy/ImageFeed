import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType : String
    let scope: String
    let createdAt: Int
    let userID: Int
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
        case createdAt = "created_at"
        case userID = "user_id"
        case username = "username"
    }
}
