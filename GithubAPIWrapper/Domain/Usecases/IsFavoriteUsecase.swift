//
//  IsFavoriteUsecase.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 16/02/26.
//

import Combine

struct IsFavoriteUsecase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(username: String) -> AnyPublisher<Bool, Never> {
        repository.isUserFavorite(username: username)
    }
}
