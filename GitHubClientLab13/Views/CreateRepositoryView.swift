import SwiftUI

struct CreateRepositoryView: View {
    @StateObject private var viewModel = CreateRepositoryViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section("Nuevo repositorio") {
                    TextField("Nombre", text: $viewModel.name)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    TextField("Descripción", text: $viewModel.repositoryDescription, axis: .vertical)
                        .lineLimit(3...6)

                    Toggle("Privado", isOn: $viewModel.isPrivate)
                }

                Section {
                    Button {
                        Task { await viewModel.createRepository() }
                    } label: {
                        HStack {
                            Spacer()
                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                Text("Crear repositorio")
                            }
                            Spacer()
                        }
                    }
                    .disabled(!viewModel.canSubmit)
                }
            }
            .navigationTitle("Crear")
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("Cerrar", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Error desconocido")
            }
            .alert("Listo", isPresented: Binding(
                get: { viewModel.successMessage != nil },
                set: { if !$0 { viewModel.successMessage = nil } }
            )) {
                Button("Aceptar") { }
            } message: {
                Text(viewModel.successMessage ?? "Repositorio creado.")
            }
        }
    }
}
