import Foundation

struct Repository: Decodable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let isPrivate: Bool
    let htmlURL: URL
    let language: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case description
        case isPrivate = "private"
        case htmlURL = "html_url"
        case language
    }
}
