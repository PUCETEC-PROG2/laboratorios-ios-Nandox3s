import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol GitHubAPIServiceProtocol {
    func fetchAuthenticatedUser() async throws -> GitHubUser
    func fetchRepositories() async throws -> [Repository]
    func createRepository(name: String, description: String?, isPrivate: Bool) async throws -> Repository
}

enum GitHubAPIError: LocalizedError {
    case missingToken
    case invalidResponse
    case httpError(statusCode: Int, message: String)
    case decodingError

    var errorDescription: String? {
        switch self {
        case .missingToken:
            return "Falta GITHUB_TOKEN. Configúralo en Product > Scheme > Edit Scheme > Run > Arguments > Environment Variables."
        case .invalidResponse:
            return "La respuesta de GitHub no es válida."
        case .httpError(let statusCode, let message):
            return "GitHub respondió con código \(statusCode): \(message)"
        case .decodingError:
            return "No se pudo interpretar la respuesta de GitHub."
        }
    }
}

private struct GitHubErrorPayload: Decodable {
    let message: String
}

final class GitHubAPIService: GitHubAPIServiceProtocol {
    static let shared = GitHubAPIService()

    private let baseURL = URL(string: "https://api.github.com")!
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
    }

    func fetchAuthenticatedUser() async throws -> GitHubUser {
        try await request(path: "/user", method: "GET", body: Optional<CreateRepositoryRequest>.none)
    }

    func fetchRepositories() async throws -> [Repository] {
        try await request(path: "/user/repos?sort=updated&per_page=100", method: "GET", body: Optional<CreateRepositoryRequest>.none)
    }

    func createRepository(name: String, description: String?, isPrivate: Bool) async throws -> Repository {
        let payload = CreateRepositoryRequest(
            name: name,
            description: description?.isEmpty == true ? nil : description,
            isPrivate: isPrivate
        )
        return try await request(path: "/user/repos", method: "POST", body: payload)
    }

    private func request<Response: Decodable, Body: Encodable>(
        path: String,
        method: String,
        body: Body?
    ) async throws -> Response {
        guard let token = ProcessInfo.processInfo.environment["GITHUB_TOKEN"],
              !token.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw GitHubAPIError.missingToken
        }

        guard let url = URL(string: path, relativeTo: baseURL)?.absoluteURL else {
            throw GitHubAPIError.invalidResponse
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("2026-03-10", forHTTPHeaderField: "X-GitHub-Api-Version")

        if let body {
            request.httpBody = try encoder.encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw GitHubAPIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let payload = try? decoder.decode(GitHubErrorPayload.self, from: data)
            throw GitHubAPIError.httpError(
                statusCode: httpResponse.statusCode,
                message: payload?.message ?? "Error desconocido"
            )
        }

        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw GitHubAPIError.decodingError
        }
    }
}
