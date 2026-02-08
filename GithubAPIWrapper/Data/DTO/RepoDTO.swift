//
//  RepoDTO.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 08/02/26.
//

struct RepoDTO: Codable {
    let id: Int
    let name: String
    let language: String?
    let description: String?
}
