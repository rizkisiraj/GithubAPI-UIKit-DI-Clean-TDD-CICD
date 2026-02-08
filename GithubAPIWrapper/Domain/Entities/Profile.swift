//
//  Profile.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 07/02/26.
//

struct Profile {
    let username: String
    let avatarUrl: String
    let bio: String
    let email: String
    let followers: Int
    let followings: Int
    var isFavorite: Bool = false
}
