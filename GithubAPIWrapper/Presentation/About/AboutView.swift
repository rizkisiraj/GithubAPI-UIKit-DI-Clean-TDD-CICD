//
//  AboutView.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 18/02/26.
//

import UIKit

final class AboutView: UIView {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupView() {
            backgroundColor = .systemBackground

            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true

            titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
            titleLabel.numberOfLines = 0

            addSubview(contentView)

            [imageView, titleLabel].forEach {
                contentView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }

            scrollView.translatesAutoresizingMaskIntoConstraints = false
            contentView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([

                contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor),

                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 260),

                titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
        }

        func render() {
            titleLabel.text = "Rizki Siraj"
        }
    
}
