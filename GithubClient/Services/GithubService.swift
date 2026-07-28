//
//  GithubService.swift
//  GithubClient
//
//  Created by Usuario invitado on 15/7/26.
//

import Foundation
import Alamofire

class GithubService {

    static let shared = GithubService()

    private let baseURL = AppConfig.apiBaseURL

    private init() {}

    private var headers: HTTPHeaders {
        [
            "Authorization": "Bearer \(AppConfig.apiToken)",
            "Accept": "application/vnd.github+json"
        ]
    }


    func getRepositories() async throws -> [Repository] {

        let response = await AF.request(
            "\(baseURL)/user/repos",
            method: .get,
            parameters: [
                "sort": "created",
                "direction": "desc",
                "per_page": 100,
                "affiliation": "owner",
                "t": Date().timeIntervalSince1970
            ],
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .serializingDecodable([Repository].self)
        .response

        if let data = response.data,
           let json = String(data: data, encoding: .utf8) {

            print("******** RESPUESTA ********")
            print(json)
        }

        switch response.result {

        case .success(let repositories):
            return repositories

        case .failure(let error):
            print("Error en el servicio de GitHub")
            print(error)
            throw error
        }
    }


    func createRepository(name: String, description: String) async throws -> Repository {
        let response = await AF.request(
            "\(baseURL)/user/repos",
            method: .post,
            parameters: [
                "name": name,
                "description": description
            ],
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .serializingDecodable(Repository.self)
        .response

        if let data = response.data,
           let json = String(data: data, encoding: .utf8) {
            print("******** RESPUESTA ********")
            print(json)
        }

        switch response.result {
        case .success(let repository):
            return repository
        case .failure(let error):
            print(error)
            throw error
        }
    }
}
