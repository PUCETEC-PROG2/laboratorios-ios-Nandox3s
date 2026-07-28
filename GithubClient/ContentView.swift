//
//  ContentView.swift
//  GithubClient
//
//  Created by Usuario invitado on 13/1/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView (selection: $selectedTab){
            RepoList()
                .tabItem{
                    Label("Repositorios", systemImage:"arrow.branch")
                }
                .tag(0)
            RepoForm(selectedTab: $selectedTab)
                .tabItem{
                    Label("Crear Repo",systemImage: "plus.circle")
                }
                .tag(1)
            Profile()
                .tabItem{
                    Label("Perfil", systemImage: "person")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
}
