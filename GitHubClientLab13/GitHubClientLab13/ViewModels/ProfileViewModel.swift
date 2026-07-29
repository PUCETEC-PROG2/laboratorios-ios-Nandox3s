import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: GitHubUser?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let service: GitHubAPIServiceProtocol

    init(service: GitHubAPIServiceProtocol = GitHubAPIService.shared) {
        self.service = service
    }

    func loadProfile(force: Bool = false) async {
        if user != nil && !force { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            user = try await service.fetchAuthenticatedUser()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refresh() async {
        await loadProfile(force: true)
    }
}
