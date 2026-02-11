//
//  FavoriteUser+Mapper.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 10/02/26.
//

import Foundation

extension FavoriteRepo {
    func toDomain() -> Repo {
        Repo(name: self.name ?? "", language: self.language ?? "", descriptions: self.descriptions ?? "")
    }
}
