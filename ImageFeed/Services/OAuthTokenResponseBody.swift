import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType : String
    let scope: String
    let createdAt: Int
    let userId: Int
    let username: String
}
