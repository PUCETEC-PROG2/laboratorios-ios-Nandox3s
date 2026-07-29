import Foundation

struct GitHubUser: Decodable, Identifiable {
    let id: Int
    let login: String
    let name: String?
    let avatarURL: URL?
    let bio: String?
    let company: String?
    let location: String?
    let email: String?
    let publicRepos: Int
    let followers: Int
    let following: Int
    let htmlURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case name
        case avatarURL = "avatar_url"
        case bio
        case company
        case location
        case email
        case publicRepos = "public_repos"
        case followers
        case following
        case htmlURL = "html_url"
    }
}
