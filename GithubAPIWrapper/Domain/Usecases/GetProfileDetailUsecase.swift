//
//  get.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 12/02/26.
//

import Combine

struct GetProfileDetailUsecase {
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func execute(username: String) -> AnyPublisher<Profile, any Error> {
        repository.getUser(username: username)
    }
}
