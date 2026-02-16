//
//  GetFavoriteProfileUsecase.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 16/02/26.
//

import Foundation
import Combine

struct GetFavoritePeopleUsecase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Profile], Never> {
        repository.getFavoriteUsers()
    }
}
