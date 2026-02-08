//
//  RepoRepository.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 08/02/26.
//
import Combine

protocol RepoRepository {
    func getRepos(username: String) -> AnyPublisher<[Repo], Error>
}
