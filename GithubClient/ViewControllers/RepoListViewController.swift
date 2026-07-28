//
//  RepoListViewController.swift
//  GithubClient
//
//  Created by Usuario invitado on 15/7/26.
//

import Foundation

@MainActor
class RepoListViewController: ObservableObject {
    @Published var repos: [Repository] = []
    @Published var errorMsg: String?
    @Published var isLoading: Bool = false
    
    private let githubService: GithubService
    
    init(service: GithubService = .shared) {
        self.githubService = service
    }
    
    func loadRepos() async {
        isLoading = true
        do {
            repos = try await githubService.getRepositories()
        } catch {
            self.errorMsg = error.localizedDescription
        }
        isLoading = false
    }
    
}
