//
//  Profile.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 07/02/26.
//

struct Profile {
    let login: String
    let bio: String
    let email: String
    let followers: Int
    let following: Int
    var isFavorite: Bool = false
}
