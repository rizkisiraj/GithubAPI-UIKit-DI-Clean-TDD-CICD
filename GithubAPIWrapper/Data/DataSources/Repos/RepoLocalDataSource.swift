//
//  RepoLocalDataSource.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 11/02/26.
//

import Combine

protocol RepoLocalDataSource {
    func getFavoriteRepos(username: String) -> AnyPublisher<[Repo], Never>
    func saveFavoriteRepos(
        username: String,
        repos: [Repo]
    ) -> AnyPublisher<Void, Error>
}
