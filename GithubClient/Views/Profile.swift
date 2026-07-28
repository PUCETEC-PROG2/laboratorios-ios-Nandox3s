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
                Text("Nando")
                    .font(.title)
                Image (uiImage: .githubLogo)
                    .resizable()
                    .scaledToFit()
                Text("Nandox3s")
                    .font(.headline)
                    .padding(.vertical)
                Text("Desarrollador iOS interesado en SwiftUI, APIs y proyectos prácticos.")
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
