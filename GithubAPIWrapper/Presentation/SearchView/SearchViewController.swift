//
//  SearchViewController.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 13/02/26.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {

    private let searchView = SearchView()
    private let searchProfileUsecase: SearchProfileUsecase
    private var cancellables = Set<AnyCancellable>()
    
    init(searchProfileUsecase: SearchProfileUsecase) {
        self.searchProfileUsecase = searchProfileUsecase
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private var items: [Profile] = [] {
        didSet {
            updateEmptyState()
            searchView.collectionView.reloadData()
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
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"

        setupCollectionView()
        setupEmptyState()
        setupCallbacks()
        setupSearch()

        loadInitialData()
    }

    // MARK: - Setup

    private func setupCollectionView() {
        searchView.collectionView.dataSource = self
        searchView.collectionView.delegate = self

        searchView.collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "Cell"
        )
    }

    private func setupEmptyState() {
        searchView.addSubview(emptyStateLabel)

        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: searchView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: searchView.centerYAnchor)
        ])
    }

    private func setupCallbacks() {
        searchView.onReachedBottom = { [weak self] in
            self?.loadMore()
        }
    }

    private func setupSearch() {
        searchView.searchBar.delegate = self
        searchView.searchBar.showsCancelButton = true
    }

    private func loadInitialData() {
        // Example
//        items = (1...20).map { "Item \($0)" }
    }

    private func loadMore() {
        let start = items.count + 1
        let more = (start..<(start + 10)).map { "Item \($0)" }
//        items.append(contentsOf: more)
    }


    private func updateEmptyState() {
        let isEmpty = items.isEmpty

        emptyStateLabel.isHidden = !isEmpty
        searchView.collectionView.isHidden = isEmpty
    }
    
    private func performSearch(keyword: String) {
  
        searchProfileUsecase.execute(query: keyword, page: 1)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("Error:", error)
                    }
                } receiveValue: { [weak self] profiles in
                    guard let self else { return }
                    
                    self.items = profiles
                    self.searchView.collectionView.reloadData()
                    
                    print("dipanggil")
                }
                .store(in: &cancellables)
        
        print("Search:", keyword)
    }

}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath
        )

        var config = UIListContentConfiguration.cell()
        config.text = items[indexPath.item].username
        cell.contentConfiguration = config

        cell.contentView.backgroundColor = .secondarySystemBackground
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

        searchView.notifyIfNearBottom(
            indexPath: indexPath,
            totalItems: items.count
        )
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

            let keyword = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            searchBar.resignFirstResponder()

            guard !keyword.isEmpty else {
//                loadInitialData()
                return
            }

            performSearch(keyword: keyword)
        }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
//        loadInitialData()
    }
}
