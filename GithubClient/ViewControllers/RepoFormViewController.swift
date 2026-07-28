//
//  RepoFormViewController.swift
//  GithubClient
//
//  Created by Usuario invitado on 22/7/26.
//
import Foundation

@MainActor
class RepoFormViewController: ObservableObject {
    @Published var repoName: String = ""
    @Published var repoDescription: String = ""
    @Published var repository: Repository? = nil
    @Published var errorMsg: String?
    @Published var isLoading: Bool = false
    
    private let githubService: GithubService
    
    init(service: GithubService = .shared) {
        self.githubService = service
    }
    func createRepository () async {
        isLoading = true
        do {
            self.repository = try await githubService.createRepository(
                name: self.repoName,
                description: self.repoDescription
            )
            self.repoName = ""
            self.repoDescription = ""
        } catch {
            errorMsg = error.localizedDescription
        }
        isLoading = false
    }
}
