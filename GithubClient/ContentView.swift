//
//  ContentView.swift
//  GithubClient
//
//  Created by Usuario invitado on 13/1/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RepoList()
                .tabItem {
                    Label("Repositorios", systemImage: "arrow.branch")
                }
            RepoForm()
                .tabItem {
                    Label("Repositorios", systemImage: "plus.circle")
                }
            Profile()
                .tabItem {
                    Label("Repositorios", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}
