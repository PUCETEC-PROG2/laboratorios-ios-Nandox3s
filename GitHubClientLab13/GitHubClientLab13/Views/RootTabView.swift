import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            RepositoriesView()
                .tabItem {
                    Label("Repos", systemImage: "folder")
                }

            CreateRepositoryView()
                .tabItem {
                    Label("Crear", systemImage: "plus.circle")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}
