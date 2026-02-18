//
//  UserRepositoryImplTest.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 17/02/26.
//

import XCTest
import Combine
import ModuleNetwork
@testable import GithubAPIWrapper

final class UserRepositoryImplTests: XCTestCase {

    private var sut: UserRepositoryImpl!
    private var apiService: MockAPIService!
    private var localDataSource: MockUserLocalDataSource!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()

        apiService = MockAPIService()
        localDataSource = MockUserLocalDataSource()
        cancellables = []

        sut = UserRepositoryImpl(
            apiService: apiService,
            userLocalDataSource: localDataSource
        )
    }

    override func tearDown() {
        sut = nil
        apiService = nil
        localDataSource = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - getUsers

    func test_getUsers_success() {

        // Given
        let dto = ProfileDTO(login: "test", avatar_url: "https://lorempicsum.com/300/300/people", bio: "test", email: "test", followers: 0, following: 0)

        let response = SearchResponseDTO(total_count: 1, items: [dto])

        apiService.stubbedResponse = response

        let exp = expectation(description: "get users")

        // When
        sut.getUsers(query: "test", page: 1)
            .sink { completion in
                if case .failure = completion {
                    XCTFail("Should not fail")
                }
            } receiveValue: { users in

                // Then
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users.first?.username, "test")
                exp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
    }

    // MARK: - getUser

    func test_getUser_success() {

        // Given
        let dto = ProfileDTO(login: "test", avatar_url: "https://lorempicsum.com/300/300/people", bio: "test", email: "test", followers: 0, following: 0)

        apiService.stubbedResponse = dto

        let exp = expectation(description: "get user")

        // When
        sut.getUser(username: "test")
            .sink { completion in
                if case .failure = completion {
                    XCTFail("Should not fail")
                }
            } receiveValue: { profile in

                // Then
                XCTAssertEqual(profile.username, "test")
                exp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
    }

    // MARK: - getFavoriteUsers

    func test_getFavoriteUsers_returnLocalData() {

        // Given
        let profile = Profile(username: "test", avatarUrl: "https://lorempicsum.com/300/300/people", bio: "test", email: "test", followers: 0, followings: 0)

        localDataSource.stubbedUsers = [profile]

        let exp = expectation(description: "favorite users")

        // When
        sut.getFavoriteUsers()
            .sink { users in

                // Then
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users.first?.username, "test")
                exp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
    }

    // MARK: - isUserFavorite

    func test_isUserFavorite_true() {

        // Given
        localDataSource.isFavoriteResult = true

        let exp = expectation(description: "is favorite")

        // When
        sut.isUserFavorite(username: "test")
            .sink { isFav in

                // Then
                XCTAssertTrue(isFav)
                exp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
    }

    // MARK: - toggleFavorite

    func test_toggleFavorite_whenAlreadyFavorite_shouldDeleteAndReturnFalse() {

        // Given
        localDataSource.isFavoriteResult = true

        let profile = Profile(username: "test", avatarUrl: "https://lorempicsum.com/300/300/people", bio: "test", email: "test", followers: 0, followings: 0)

        let exp = expectation(description: "toggle favorite delete")

        // When
        sut.toggleFavorite(profile: profile)
            .sink { completion in
                if case .failure = completion {
                    XCTFail()
                }
            } receiveValue: { result in

                // Then
                XCTAssertFalse(result)
                XCTAssertTrue(self.localDataSource.deleteCalled)
                XCTAssertFalse(self.localDataSource.saveCalled)
                exp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
    }

    func test_toggleFavorite_whenNotFavorite_shouldSaveAndReturnTrue() {

        // Given
        localDataSource.isFavoriteResult = false

        let profile = Profile(username: "test", avatarUrl: "https://lorempicsum.com/300/300/people", bio: "test", email: "test", followers: 0, followings: 0)

        let exp = expectation(description: "toggle favorite save")

        // When
        sut.toggleFavorite(profile: profile)
            .sink { completion in
                if case .failure = completion {
                    XCTFail()
                }
            } receiveValue: { result in

                // Then
                XCTAssertTrue(result)
                XCTAssertTrue(self.localDataSource.saveCalled)
                XCTAssertFalse(self.localDataSource.deleteCalled)
                exp.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [exp], timeout: 1)
    }
}

final class MockAPIService: APIServiceProtocol {

    var stubbedResponse: Any!

    func fetchData<T>(url: String) -> AnyPublisher<T, Error> where T : Decodable {

        let result = stubbedResponse as! T

        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

final class MockUserLocalDataSource: UserLocalDataSource {

    var stubbedUsers: [Profile] = []
    var isFavoriteResult: Bool = false

    var saveCalled = false
    var deleteCalled = false

    func getFavoriteUsers() -> AnyPublisher<[Profile], Never> {
        Just(stubbedUsers)
            .eraseToAnyPublisher()
    }

    func isFavorite(username: String) -> AnyPublisher<Bool, Never> {
        Just(isFavoriteResult)
            .eraseToAnyPublisher()
    }

    func saveFavorite(_ profile: Profile) -> AnyPublisher<Void, Error> {
        saveCalled = true
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func deleteFavorite(username: String) -> AnyPublisher<Void, Error> {
        deleteCalled = true
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
