//
//  RepoItem.swift
//  GithubClient
//
//  Created by Usuario invitado on 9/7/26.
//

import SwiftUI

struct RepoItem: View {
    
    let repository: Repository
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: repository.owner.avatarUrl)) {
                image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image (uiImage: .githubLogo)
                    .resizable()
                    .scaledToFit()
            }.frame(width: 80, height: 80)
            
            
            VStack(alignment: .leading){
                Text(repository.name)
                    .font(.title2)
                
                if let description = repository.description {
                    Text(description)
                        .font(.caption)
                        .padding(.top, 0.1)
                }
                if let language = repository.language {
                    HStack{
                        Text("Lenguaje")
                            .fontWeight(.bold)
                        Spacer()
                        Text("Swift")
                    }
                    .font(.caption2)
                    .padding(.top, 0.1)
                }
            }
        }
        .padding(.leading)
    }
}

#Preview {
    RepoItem(repository: Repository.sampleData[0])
}
