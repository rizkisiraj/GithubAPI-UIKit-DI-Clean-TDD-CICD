//
//  UserLocalDataSource.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 10/02/26.
//

import Combine

protocol UserLocalDataSource {
    func getFavoriteUsers() -> AnyPublisher<[Profile], Never>
    func isFavorite(username: String) -> AnyPublisher<Bool, Never>
    func saveFavorite(_ profile: Profile) -> AnyPublisher<Void, Error>
    func deleteFavorite(username: String) -> AnyPublisher<Void, Error>
}
