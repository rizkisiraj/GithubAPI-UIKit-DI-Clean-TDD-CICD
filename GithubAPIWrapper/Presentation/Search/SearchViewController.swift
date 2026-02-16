//
//  SearchViewController.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 13/02/26.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {

    private let container: DependencyContainer
    private let searchView = SearchView()
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
            SearchGridCell.self,
            forCellWithReuseIdentifier: SearchGridCell.reuseIdentifier
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
    
    private func goToDetail(item: Profile) {
        let vc = ProfileDetailViewController(
            username: item.username,
            getProfileDetailUsecase: container.getProfileDetailUsecase,
            getRepoUsecase: container.getReposUsecase)
        
        navigationController?.pushViewController(vc, animated: true)
    }


    private func updateEmptyState() {
        let isEmpty = items.isEmpty

        emptyStateLabel.isHidden = !isEmpty
        searchView.collectionView.isHidden = isEmpty
    }
    
    private func performSearch(keyword: String) {
  
        container.searchProfileUsecase.execute(query: keyword, page: 1)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        print("Error:", error)
                    }
                } receiveValue: { [weak self] profiles in
                    guard let self else { return }
                    
                    self.items = profiles
                    self.searchView.collectionView.reloadData()
                    
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
            withReuseIdentifier: SearchGridCell.reuseIdentifier,
            for: indexPath
        ) as! SearchGridCell

        cell.configure(with: items[indexPath.item])

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let profile = items[indexPath.item]
        print(profile)
        goToDetail(item: profile)
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

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let spacing: CGFloat = 8
        let totalSpacing = spacing

        let width = (collectionView.bounds.width - totalSpacing) / 2

        return CGSize(width: width, height: width * 1.2)
    }
}


