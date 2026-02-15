//
//  getRepoUsecase.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 12/02/26.
//

import Combine

struct GetRepoUsecase {
    private let repository: RepoRepository
    
    init(repository: RepoRepository) {
        self.repository = repository
    }
    
    func execute(username: String) -> AnyPublisher<[Repo], any Error> {
        repository.getRepos(username: username)
    }
}
