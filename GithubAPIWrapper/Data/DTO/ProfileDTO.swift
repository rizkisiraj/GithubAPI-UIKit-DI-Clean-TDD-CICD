//
//  ProfileDTO.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 08/02/26.
//

struct ProfileDTO: Codable {
    let login: String
    let avatar_url: String?
    let bio: String?
    let email: String
    let followers: Int
    let following: Int
}
