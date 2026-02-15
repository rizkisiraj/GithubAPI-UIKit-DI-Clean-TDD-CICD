//
//  DetailView.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 15/02/26.
//

import UIKit

final class ProfileDetailView: UIView {

    // MARK: - UI

    let scrollView = UIScrollView()
    private let contentView = UIView()

    let avatarImageView = UIImageView()
    let usernameLabel = UILabel()
    let bioLabel = UILabel()

    let leftStatLabel = UILabel()
    let rightStatLabel = UILabel()

    let reposStackView = UIStackView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setupViews() {

        backgroundColor = .systemBackground

        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill

        usernameLabel.font = .boldSystemFont(ofSize: 20)
        usernameLabel.textAlignment = .center

        bioLabel.font = .systemFont(ofSize: 14)
        bioLabel.textColor = .secondaryLabel
        bioLabel.textAlignment = .center
        bioLabel.numberOfLines = 0

        leftStatLabel.font = .boldSystemFont(ofSize: 18)
        leftStatLabel.textAlignment = .center

        rightStatLabel.font = .boldSystemFont(ofSize: 18)
        rightStatLabel.textAlignment = .center

        reposStackView.axis = .vertical
        reposStackView.spacing = 12

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        [
            avatarImageView,
            usernameLabel,
            bioLabel,
            leftStatLabel,
            rightStatLabel,
            reposStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayout() {

        NSLayoutConstraint.activate([

            // Scroll
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Avatar
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            // Username
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            // Bio
            bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 6),
            bioLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            bioLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            // Left stat
            leftStatLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 24),
            leftStatLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leftStatLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),

            // Right stat
            rightStatLabel.topAnchor.constraint(equalTo: leftStatLabel.topAnchor),
            rightStatLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rightStatLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),

            // Repos stack
            reposStackView.topAnchor.constraint(equalTo: leftStatLabel.bottomAnchor, constant: 24),
            reposStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reposStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            reposStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }
    
    
}

final class RepoItemView: UIView {

    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {

        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12

        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }
}
