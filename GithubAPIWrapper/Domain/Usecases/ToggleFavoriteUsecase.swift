//
//  SaveProfileToFavoriteUsecase.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 16/02/26.
//

import Foundation
import Combine

struct ToggleFavoriteUsecase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(profile: Profile) -> AnyPublisher<Bool, any Error> {
        repository.toggleFavorite(profile: profile)
    }
}
