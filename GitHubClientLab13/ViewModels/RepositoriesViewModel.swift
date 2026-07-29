import Foundation
import Combine

@MainActor
final class RepositoriesViewModel: ObservableObject {
    @Published private(set) var repositories: [Repository] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let service: GitHubAPIServiceProtocol

    init(service: GitHubAPIServiceProtocol = GitHubAPIService.shared) {
        self.service = service
    }

    func load(force: Bool = false) async {
        if !repositories.isEmpty && !force { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            repositories = try await service.fetchRepositories()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
