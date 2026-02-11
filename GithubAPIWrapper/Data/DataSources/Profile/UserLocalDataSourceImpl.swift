//
//  LocalDataSource.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 10/02/26.
//
import CoreData
import Combine

final class UserLocalDataSourceImpl: UserLocalDataSource {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func getFavoriteUsers() -> AnyPublisher<[Profile], Never> {

        Future { promise in
            self.context.perform {
                let request = FavoriteProfile.fetchRequest()

                let result = (try? self.context.fetch(request)) ?? []

                let profiles = result.map { $0.toDomain() }

                promise(.success(profiles))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func isFavorite(username: String) -> AnyPublisher<Bool, Never> {

        Future { promise in
            self.context.perform {

                let request = FavoriteProfile.fetchRequest()
                request.fetchLimit = 1
                request.predicate = NSPredicate(
                    format: "username == %@",
                    username
                )

                do {
                    let count = try self.context.count(for: request)
                    promise(.success(count > 0))
                } catch {
                    promise(.success(false))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func saveFavorite(_ profile: Profile) -> AnyPublisher<Void, Error> {

        Future { promise in
            self.context.perform {

                let entity = FavoriteProfile(context: self.context)
                entity.username = profile.username
                entity.avatarURL = profile.avatarUrl
                entity.bio = profile.bio
                entity.email = profile.email
                entity.followers = Int32(profile.followers)
                entity.followings = Int32(profile.followings)

                do {
                    try self.context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func deleteFavorite(username: String) -> AnyPublisher<Void, Error> {

        Future { promise in
            self.context.perform {

                let request = FavoriteProfile.fetchRequest()
                request.predicate = NSPredicate(
                    format: "username == %@",
                    username
                )

                do {
                    let result = try self.context.fetch(request)
                    result.forEach { self.context.delete($0) }
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

