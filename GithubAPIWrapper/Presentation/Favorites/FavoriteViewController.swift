//
//  SearchViewController.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 13/02/26.
//

import UIKit
import Combine

final class FavoriteViewController: UIViewController {

    private let container: DependencyContainer
    private let favoriteView = FavoriteView()
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DependencyContainer) {
        self.container = container
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private var items: [Profile] = [] {
        didSet {
            updateEmptyState()
            favoriteView.collectionView.reloadData()
        }
    }

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No data available"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    // MARK: - Lifecycle

    override func loadView() {
        view = favoriteView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"

        setupCollectionView()
        setupEmptyState()

        loadInitialData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadInitialData()
    }


    // MARK: - Setup

    private func setupCollectionView() {
        favoriteView.collectionView.dataSource = self
        favoriteView.collectionView.delegate = self

        favoriteView.collectionView.register(
            SearchGridCell.self,
            forCellWithReuseIdentifier: SearchGridCell.reuseIdentifier
        )
    }

    private func setupEmptyState() {
        favoriteView.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: favoriteView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: favoriteView.centerYAnchor)
        ])
    }

    private func updateEmptyState() {
        let isEmpty = items.isEmpty

        emptyStateLabel.isHidden = !isEmpty
        favoriteView.collectionView.isHidden = isEmpty
    }
    
    private func loadInitialData() {
        container.getFavoriteProfileUsecase.execute()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("Error:", error)
                    }
                } receiveValue: { [weak self] profiles in
                    guard let self else { return }
                    
                    self.items = profiles
                    self.favoriteView.collectionView.reloadData()
                    
                }
                .store(in: &cancellables)
        
    }

}

// MARK: - UICollectionViewDataSource

extension FavoriteViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SearchGridCell.reuseIdentifier,
            for: indexPath
        ) as! SearchGridCell

        cell.configure(with: items[indexPath.item])

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FavoriteViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

        favoriteView.notifyIfNearBottom(
            indexPath: indexPath,
            totalItems: items.count
        )
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let spacing: CGFloat = 8
        let totalSpacing = spacing

        let width = (collectionView.bounds.width - totalSpacing) / 2

        return CGSize(width: width, height: width * 1.2)
    }
}


