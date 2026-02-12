//
//  getUserUsecase.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 12/02/26.
//

import Foundation
import Combine

struct SearchProfileUsecase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(query: String, page: Int) -> AnyPublisher<[Profile], any Error> {
        repository.getUsers(query: query, page: page)
    }
}
