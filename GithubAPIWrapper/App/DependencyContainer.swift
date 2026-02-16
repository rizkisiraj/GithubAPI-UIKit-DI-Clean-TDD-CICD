//
//  DependencyContainer.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 12/02/26.
//
import Foundation
import CoreData

final class DependencyContainer {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GithubAPIWrapper")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    lazy var apiService: APIService = {
        APIService()
    }()
    
    lazy var userLocalDataSource: UserLocalDataSource = {
        UserLocalDataSourceImpl(
            context: viewContext
        )
    }()
    
    lazy var repoLocalDataSource: RepoLocalDataSource = {
        RepoLocalDataSourceImpl(
            context: viewContext
        )
    }()
    
    lazy var userRepository: UserRepository = {
        UserRepositoryImpl(
            apiService: apiService,
            userLocalDataSource: userLocalDataSource
        )
    }()
    
    lazy var repoRepository: RepoRepository = {
        RepoRepositoryImpl(
            apiService: apiService,
            repoLocalDataSource: repoLocalDataSource
        )
    }()
    
    lazy var searchProfileUsecase: SearchProfileUsecase = {
        SearchProfileUsecase(repository: userRepository)
    }()
    
    lazy var getProfileDetailUsecase: GetProfileDetailUsecase = {
        GetProfileDetailUsecase(repository: userRepository)
    }()
    
    lazy var getReposUsecase: GetRepoUsecase = {
        GetRepoUsecase(repository: repoRepository)
    }()
    
    lazy var isUserFavoriteUsecase: IsFavoriteUsecase = {
        IsFavoriteUsecase(repository: userRepository)
    }()
    
    lazy var toggleFavoriteUsecase: ToggleFavoriteUsecase = {
        ToggleFavoriteUsecase(repository: userRepository)
    }()
    
    lazy var getFavoriteProfileUsecase: GetFavoritePeopleUsecase = {
        GetFavoritePeopleUsecase(repository: userRepository)
    }()
}
