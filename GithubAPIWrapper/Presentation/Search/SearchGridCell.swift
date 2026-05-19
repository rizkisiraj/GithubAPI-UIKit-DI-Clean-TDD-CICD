//
//  SearchGridCell.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 14/02/26.
//

import UIKit

final class SearchGridCell: UICollectionViewCell {

    static let reuseIdentifier = "SearchGridCell"

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private var imageTask: URLSessionDataTask?
    private var currentImageURL: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        imageTask = nil
        currentImageURL = nil
        imageView.image = nil
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupView() {

        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 2
        titleLabel.font = .preferredFont(forTextStyle: .headline)

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4)
        ])
    }

    func configure(with profile: Profile) {
        titleLabel.text = profile.username
        imageView.image = nil
        
        currentImageURL = profile.avatarUrl

        imageTask?.cancel()
        
        guard let url = URL(string: profile.avatarUrl) else {
            return
        }
        
        let cacheKey = url.absoluteString as NSString
        imageTask = ImageLoader.shared.loadImage(
                    from: profile.avatarUrl
        ) { [weak self] image in
            guard let self else { return }
            
            guard self.currentImageURL == profile.avatarUrl else {
                return
            }
            
            self.imageView.image = image
        }
    }
}
