//
//  UserRepository.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 08/02/26.
//
import Combine

protocol UserRepository {
    func getUsers(query: String, page: Int) -> AnyPublisher<[Profile], Error>
    func getUser(username: String) -> AnyPublisher<Profile, Error>
    func getFavoriteUsers() -> AnyPublisher<[Profile], Never>
    func isUserFavorite(username: String) -> AnyPublisher<Bool, Never>
    func toggleFavorite(profile: Profile) -> AnyPublisher<Bool, Error>
}
