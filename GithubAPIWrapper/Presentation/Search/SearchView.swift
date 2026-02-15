//
//  SearchView.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 13/02/26.
//

import UIKit

final class SearchView: UIView {

    let collectionView: UICollectionView
    let searchBar = UISearchBar()

    var onReachedBottom: (() -> Void)?

    private let layout: UICollectionViewFlowLayout

    override init(frame: CGRect) {

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        self.layout = layout

        self.collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupView() {

        backgroundColor = .systemBackground

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground

        addSubview(searchBar)
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let numberOfColumns: CGFloat = 2
        let spacing = layout.minimumInteritemSpacing

        let totalSpacing = spacing * (numberOfColumns - 1)
        let availableWidth = collectionView.bounds.width - totalSpacing

        let itemWidth = floor(availableWidth / numberOfColumns)

        layout.itemSize = CGSize(
            width: itemWidth,
            height: itemWidth * 0.75
        )
    }

    // MARK: - Pagination helper

    func notifyIfNearBottom(indexPath: IndexPath, totalItems: Int) {

        guard totalItems > 0 else { return }

        let threshold = max(totalItems - 4, 0)

        if indexPath.item == threshold {
            onReachedBottom?()
        }
    }
}
