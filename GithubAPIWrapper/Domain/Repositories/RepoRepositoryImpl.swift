//
//  RepoRepositoryImpl.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 11/02/26.
//

import Combine

class RepoRepositoryImpl: RepoRepository {
    
    private let apiService: APIService
    private let repoLocalDataSource: RepoLocalDataSource
    
    init(apiService: APIService, repoLocalDataSource: RepoLocalDataSource) {
        self.apiService = apiService
        self.repoLocalDataSource = repoLocalDataSource
    }
    
    func getRepos(username: String) -> AnyPublisher<[Repo], any Error> {
        apiService
            .fetchData(url: "/users/\(username)/repos?per_page=3&page=1&sort=created&direction=desc")
            .map { (responseDTO: [RepoDTO]) in
                return responseDTO.map { $0.toDomain() }
            }
            .eraseToAnyPublisher()
    }
    
    func getFavoriteRepos(username: String) -> AnyPublisher<[Repo], Never> {
        repoLocalDataSource
            .getFavoriteRepos(username: username)
    }
    
    func saveFavoriteRepos(username: String, repos: [Repo]) -> AnyPublisher<Void, any Error> {
        repoLocalDataSource.saveFavoriteRepos(username: username, repos: repos)
    }
    
    
}
