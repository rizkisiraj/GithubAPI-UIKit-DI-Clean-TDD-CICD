//
//  ProfileDTO+Mapper.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 11/02/26.
//
import Foundation

extension ProfileDTO {
    func toDomain() -> Profile {
        Profile(
            username: self.login,
            avatarUrl: self.avatar_url ?? "",
            bio: self.bio ?? "",
            email: self.email,
            followers: self.followers,
            followings: self.following
        )
    }
}
