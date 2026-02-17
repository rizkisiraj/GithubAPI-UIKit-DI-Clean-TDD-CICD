//
//  UserRepositoryImpl.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 10/02/26.
//

import Combine

class UserRepositoryImpl: UserRepository {
    private let apiService: APIServiceProtocol
    private let userLocalDataSource: UserLocalDataSource
    
    init(apiService: APIServiceProtocol, userLocalDataSource: UserLocalDataSource) {
        self.apiService = apiService
        self.userLocalDataSource = userLocalDataSource
    }
    
    func getUsers(query: String, page: Int) -> AnyPublisher<[Profile], any Error> {
        apiService
            .fetchData(url: "/search/users?q=\(query)&page=\(page)&per_page=8")
            .map { (response: SearchResponseDTO) in
                response.items.map { $0.toDomain() }
            }
            .eraseToAnyPublisher()
    }
    
    func getUser(username: String) -> AnyPublisher<Profile, any Error> {
        apiService.fetchData(url: "/users/\(username)")
            .tryMap { (responseDTO: ProfileDTO) in
                return responseDTO.toDomain()
            }
            .eraseToAnyPublisher()
    }
    
    func getFavoriteUsers() -> AnyPublisher<[Profile], Never> {
        userLocalDataSource.getFavoriteUsers()
    }
    
    func isUserFavorite(username: String) -> AnyPublisher<Bool, Never> {
        userLocalDataSource.isFavorite(username: username)
    }
    
    func toggleFavorite(profile: Profile) -> AnyPublisher<Bool, Error> {
        userLocalDataSource
            .isFavorite(username: profile.username)
            .setFailureType(to: Error.self)
            .flatMap { isFav in
                if isFav {
                    return self
                        .userLocalDataSource.deleteFavorite(username: profile.username)
                        .map { false }
                        .eraseToAnyPublisher()
                } else {
                    return self
                        .userLocalDataSource.saveFavorite(profile)
                        .map { true }
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    
}
