import Foundation

struct CreateRepositoryRequest: Encodable {
    let name: String
    let description: String?
    let isPrivate: Bool

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case isPrivate = "private"
    }
}
