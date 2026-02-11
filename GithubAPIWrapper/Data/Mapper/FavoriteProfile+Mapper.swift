//
//  FavoriteUser+Mapper.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 10/02/26.
//

import Foundation

extension FavoriteProfile {
    func toDomain() -> Profile {
        Profile(
            username: self.username ?? "",
            avatarUrl: self.avatarURL ?? "",
            bio: self.bio ?? "",
            email: self.email ?? "",
            followers: Int(self.followers),
            followings: Int(self.followings)
        )
    }
}
