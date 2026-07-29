import Foundation
import Combine

@MainActor
final class CreateRepositoryViewModel: ObservableObject {
    @Published var name = ""
    @Published var repositoryDescription = ""
    @Published var isPrivate = false
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let service: GitHubAPIServiceProtocol

    init(service: GitHubAPIServiceProtocol = GitHubAPIService.shared) {
        self.service = service
    }

    var canSubmit: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }

    func createRepository() async {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else {
            errorMessage = "El nombre del repositorio no puede estar vacío."
            return
        }

        isLoading = true
        errorMessage = nil
        successMessage = nil
        defer { isLoading = false }

        do {
            let repository = try await service.createRepository(
                name: cleanName,
                description: repositoryDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                isPrivate: isPrivate
            )
            successMessage = "Repositorio \(repository.name) creado correctamente."
            name = ""
            repositoryDescription = ""
            isPrivate = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
