import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.user == nil {
                    ProgressView("Obteniendo perfil de GitHub...")
                } else if let user = viewModel.user {
                    ScrollView {
                        VStack(spacing: 22) {
                            AsyncImage(url: user.avatarURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 120, height: 120)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                case .failure:
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.secondary)
                                        .frame(width: 120, height: 120)
                                @unknown default:
                                    EmptyView()
                                }
                            }

                            VStack(spacing: 4) {
                                Text(user.name ?? user.login)
                                    .font(.title2.bold())
                                    .multilineTextAlignment(.center)

                                Text("@\(user.login)")
                                    .foregroundStyle(.secondary)
                            }

                            if let bio = user.bio, !bio.isEmpty {
                                Text(bio)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }

                            HStack(spacing: 0) {
                                StatView(title: "Repos", value: user.publicRepos)
                                Divider().frame(height: 44)
                                StatView(title: "Followers", value: user.followers)
                                Divider().frame(height: 44)
                                StatView(title: "Following", value: user.following)
                            }
                            .padding(.vertical, 12)
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))

                            VStack(alignment: .leading, spacing: 14) {
                                if let company = user.company, !company.isEmpty {
                                    ProfileInfoRow(icon: "building.2", text: company)
                                }

                                if let location = user.location, !location.isEmpty {
                                    ProfileInfoRow(icon: "location", text: location)
                                }

                                if let email = user.email, !email.isEmpty {
                                    ProfileInfoRow(icon: "envelope", text: email)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Link(destination: user.htmlURL) {
                                Label("Abrir perfil en GitHub", systemImage: "safari")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
                } else {
                    VStack(spacing: 14) {
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .font(.system(size: 52))
                            .foregroundStyle(.secondary)
                        Text("No se pudo cargar el perfil")
                            .font(.headline)
                        Text("Verifica que GITHUB_TOKEN esté configurado en el esquema de Xcode.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Reintentar") {
                            Task { await viewModel.refresh() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .task {
                await viewModel.loadProfile()
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("Reintentar") {
                    Task { await viewModel.refresh() }
                }
                Button("Cerrar", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Error desconocido")
            }
        }
    }
}

private struct StatView: View {
    let title: String
    let value: Int

    var body: some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ProfileInfoRow: View {
    let icon: String
    let text: String

    var body: some View {
        Label {
            Text(text)
        } icon: {
            Image(systemName: icon)
                .frame(width: 24)
        }
        .foregroundStyle(.primary)
    }
}
