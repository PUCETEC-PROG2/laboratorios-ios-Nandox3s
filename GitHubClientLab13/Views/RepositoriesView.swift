import SwiftUI

struct RepositoriesView: View {
    @StateObject private var viewModel = RepositoriesViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.repositories.isEmpty {
                    ProgressView("Cargando repositorios...")
                } else if viewModel.repositories.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "folder")
                            .font(.system(size: 46))
                            .foregroundStyle(.secondary)
                        Text("Sin repositorios")
                            .font(.headline)
                        Text("No se encontraron repositorios para esta cuenta.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    List(viewModel.repositories) { repository in
                        Link(destination: repository.htmlURL) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(repository.name)
                                        .font(.headline)
                                    Spacer()
                                    if repository.isPrivate {
                                        Image(systemName: "lock.fill")
                                            .foregroundStyle(.secondary)
                                    }
                                }

                                if let description = repository.description, !description.isEmpty {
                                    Text(description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                }

                                if let language = repository.language {
                                    Text(language)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .refreshable {
                        await viewModel.load(force: true)
                    }
                }
            }
            .navigationTitle("Repositorios")
            .task {
                await viewModel.load()
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("Reintentar") {
                    Task { await viewModel.load(force: true) }
                }
                Button("Cerrar", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Error desconocido")
            }
        }
    }
}
