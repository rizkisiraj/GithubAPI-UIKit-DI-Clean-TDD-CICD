//
//  RepoDTO+Mapper.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 11/02/26.
//

import Foundation

extension RepoDTO {
    func toDomain() -> Repo {
        Repo(name: self.name, language: self.language ?? "", descriptions: self.description ?? "")
    }
}
