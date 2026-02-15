//
//  DetailController.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 15/02/26.
//

import UIKit
import Combine

final class ProfileDetailViewController: UIViewController {

    private let contentView = ProfileDetailView()

    private let username: String
    private let getProfileDetailUsecase: GetProfileDetailUsecase
    private let getReposUsecase: GetRepoUsecase

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(
        username: String,
        getProfileDetailUsecase: GetProfileDetailUsecase,
        getRepoUsecase: GetRepoUsecase
    ) {
        self.username = username
        self.getProfileDetailUsecase = getProfileDetailUsecase
        self.getReposUsecase = getRepoUsecase
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchProfile()
        fetchRepos()
    }

    // MARK: - API

    private func fetchProfile() {

        getProfileDetailUsecase.execute(username: username)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.showError(error)
                }
            } receiveValue: { [weak self] profile in
                self?.renderProfile(profile)
            }
            .store(in: &cancellables)
    }

    private func fetchRepos() {

        getReposUsecase.execute(username: username)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.showError(error)
                }
            } receiveValue: { [weak self] repos in
                self?.renderRepos(repos)
            }
            .store(in: &cancellables)
    }

    // MARK: - Render

    private func renderProfile(_ profile: Profile) {

        contentView.usernameLabel.text = profile.username
        contentView.bioLabel.text = profile.bio

        contentView.leftStatLabel.text =
        "\(profile.followers)\nFollowers"

        contentView.rightStatLabel.text =
        "\(profile.followings)\nFollowing"

        contentView.leftStatLabel.numberOfLines = 2
        contentView.rightStatLabel.numberOfLines = 2

        // avatar loading is up to you
    }

    private func renderRepos(_ repos: [Repo]) {

        contentView.reposStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }

        repos.forEach { repo in
            let view = RepoItemView()
            view.titleLabel.text = repo.name
            contentView.reposStackView.addArrangedSubview(view)
        }
    }

    // MARK: - Error

    private func showError(_ error: Error) {

        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
