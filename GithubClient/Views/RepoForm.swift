//
//  RepoForm.swift
//  GithubClient
//
//  Created by Usuario invitado on 8/7/26.
//


import SwiftUI

struct RepoForm: View {
    @StateObject private var viewController = RepoFormViewController()
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if viewController.isLoading {
                    ProgressView("Creando repositorio...")
                } else {
                    
                    Spacer()
                    TextField(
                        "",
                        text: $viewController.repoName,
                        prompt: Text("Nombre del repositorio")
                            .foregroundStyle(.accent.opacity(0.6))
                    )
                    .textFieldStyle(.roundedBorder)
                    .padding(.vertical)
                    
                    TextField(
                        "",
                        text: $viewController.repoDescription,
                        prompt: Text("Descripcion del repositorio")
                            .foregroundStyle(.accent.opacity(0.6)),
                        axis: .vertical,
                    )
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(4...10)
                    .padding(.vertical)
                    
                    if let errorMsg = viewController.errorMsg {
                        Text(errorMsg)
                            .foregroundStyle(.red)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await viewController.createRepository()
                            if viewController.errorMsg == nil {
                                selectedTab = 0
                            }
                        }
                    }){
                        Label("Guardar Repo",systemImage:
                                "square.and.arrow.down")
                        .padding(.all, 8)
                        
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Formulario de repositorio")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    RepoForm(selectedTab: .constant(1))
}
