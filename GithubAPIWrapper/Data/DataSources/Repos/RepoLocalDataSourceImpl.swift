//
//  RepoLocalDataSourceImpl.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 11/02/26.
//

import CoreData
import Combine

final class RepoLocalDataSourceImpl: RepoLocalDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func getFavoriteRepos(username: String)
        -> AnyPublisher<[Repo], Never> {

        Future { promise in
            self.context.perform {

                let request = FavoriteRepo.fetchRequest()
                request.predicate = NSPredicate(
                    format: "profile.username == %@",
                    username
                )

                let result = (try? self.context.fetch(request)) ?? []

                let repos = result.map { $0.toDomain() }

                promise(.success(repos))
            }
        }
        .eraseToAnyPublisher()
    }

    func saveFavoriteRepos(
        username: String,
        repos: [Repo]
    ) -> AnyPublisher<Void, Error> {

        Future { promise in
            self.context.perform {

                do {
                    let userRequest = FavoriteProfile.fetchRequest()
                    userRequest.fetchLimit = 1
                    userRequest.predicate = NSPredicate(
                        format: "username == %@",
                        username
                    )

                    guard let user = try self.context
                        .fetch(userRequest)
                        .first else {

                        promise(.failure(
                            NSError(
                                domain: "FavoriteUserNotFound",
                                code: 0
                            )
                        ))
                        return
                    }

                    // delete old repos (simple cache strategy)
                    let oldRepos = user.repos as? Set<FavoriteRepo> ?? []
                    oldRepos.forEach { self.context.delete($0) }

                    // insert new
                    for repo in repos {

                        let entity = FavoriteRepo(context: self.context)
                        entity.name = repo.name
                        entity.descriptions = repo.descriptions
                        entity.language = repo.language
                        entity.profile = user
                    }

                    try self.context.save()
                    promise(.success(()))

                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

}

