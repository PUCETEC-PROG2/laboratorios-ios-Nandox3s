//
//  RepoList.swift
//  GithubClient
//
//  Created by Usuario invitado on 15/7/26.
//

import SwiftUI

struct RepoList: View {

    @StateObject private var viewController = RepoListViewController()

    var body: some View {
        NavigationStack {
            Group {
                if viewController.isLoading {
                    ProgressView("Cargando repositorios...")
                } else if let errorMsg = viewController.errorMsg {
                    Text(errorMsg)
                        .foregroundStyle(.red)
                        .padding()
                } else {
                    List(viewController.repos) { repo in
                        RepoItem(repository: repo)
                    }
                }
            }
            .navigationTitle("Repositorios")
        }
        .task {
            await viewController.loadRepos()
        }
    }
}

#Preview {
    RepoList()
}
