//
//  GithubUser.swift
//  GithubClient
//
//  Created by Usuario invitado on 15/7/26.
//
import Foundation

struct GithubUser: Decodable {
    let login: String
    let name: String?
    let avatarUrl: String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case name
        case avatarUrl = "avatar_url"
        case bio
    }
}
