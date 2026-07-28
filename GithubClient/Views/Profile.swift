//
//  Profile.swift
//  GithubClient
//
//  Created by Usuario invitado on 8/7/26.
//

import SwiftUI

struct Profile: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Josue Herrera")
                    .font(.title)
                Image (uiImage: .githubLogo)
                    .resizable()
                    .scaledToFit()
                Text("jxherrera")
                    .font(.headline)
                    .padding(.vertical)
                Text("lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec at massa sit amet risus hendrerit")
                    .font(.caption)
            }
            .padding()
            .navigationTitle("Perfil de usuario")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    Profile()
}
