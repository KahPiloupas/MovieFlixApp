//
//  MovieGridViewController.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 17/05/25.
//

import UIKit

protocol MovieGridViewProtocol: AnyObject {
    func displayMovies(_ movies: [Movie])
    func appendMovies(_ movies: [Movie])
    func displaySearchResults(_ movies: [Movie])
    func displayError(_ message: String)
    func showLoading(_ isLoading: Bool)
    func updateCategoryTitle(_ title: String)
}

class MovieGridViewController: UIViewController {
    
    var presenter: MovieGridPresenterProtocol!
    
    private var allMovies: [Movie] = []
    private var filteredMovies: [Movie] = []
    
    private let collectionView: UICollectionView
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let loadingFooter = UIActivityIndicatorView(style: .medium)
    private let emptyStateLabel = UILabel()
    
    private let columns: CGFloat = 2
    private let spacing: CGFloat = 10
    
    private var isNearBottomOfScroll: Bool = false
    
    // MARK: - Initialization
    
    init() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupLoadingFooter()
        setupNotifications()
        presenter.viewDidLoad()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFavoritesChanged),
            name: .favoritesChanged,
            object: nil
        )
    }
    
    @objc private func handleFavoritesChanged() {
        let visibleItems = collectionView.indexPathsForVisibleItems
        if !visibleItems.isEmpty {
            collectionView.reloadItems(at: visibleItems)
        }
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Filmes"
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar filme..."
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateLabel.text = "Nenhum filme encontrado"
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.textColor = .darkGray
        emptyStateLabel.font = .systemFont(ofSize: 18)
        emptyStateLabel.isHidden = true
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateLabel)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.register(MovieGridCell.self, forCellWithReuseIdentifier: MovieGridCell.identifier)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = spacing
            layout.minimumInteritemSpacing = spacing
            layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
    }
    
    private func setupLoadingFooter() {
        loadingFooter.hidesWhenStopped = true
        loadingFooter.color = .darkGray
        loadingFooter.translatesAutoresizingMaskIntoConstraints = false
    }
    

    
    // MARK: - Infinite Scroll
    
    private func checkIfNearBottomOfScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if let searchController = navigationItem.searchController, searchController.isActive &&
            !(searchController.searchBar.text?.isEmpty ?? true) {
            return
        }
        
        let threshold = contentHeight - frameHeight * 1.25
        let isNearBottom = offset > threshold && contentHeight > frameHeight
        
        if isNearBottom && !isNearBottomOfScroll && !presenter.isLoadingMore {
            isNearBottomOfScroll = true
            presenter.loadMoreMovies()
            showLoadingFooter(true)
        } else if !isNearBottom {
            isNearBottomOfScroll = false
        }
    }
    
    private func showLoadingFooter(_ show: Bool) {
        if show {
            loadingFooter.startAnimating()
            
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50))
            footerView.addSubview(loadingFooter)
            
            loadingFooter.center = CGPoint(x: footerView.bounds.midX, y: footerView.bounds.midY)
            
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 50)
            }
        } else {
            loadingFooter.stopAnimating()
            
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.footerReferenceSize = .zero
            }
        }
    }
    
    // MARK: - Movie Filtering
    
    private func updateUI() {
        emptyStateLabel.isHidden = !filteredMovies.isEmpty
        collectionView.isHidden = filteredMovies.isEmpty
        collectionView.reloadData()
    }
    
    // MARK: - Display Movies
    
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            collectionView.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            collectionView.isHidden = filteredMovies.isEmpty
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MovieGridViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieGridCell.identifier, for: indexPath) as? MovieGridCell else {
            return UICollectionViewCell()
        }
        
        let movie = filteredMovies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = filteredMovies[indexPath.item]
        presenter.didSelectMovie(movie)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkIfNearBottomOfScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            checkIfNearBottomOfScroll(scrollView)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieGridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - spacing * (columns + 1)) / columns
        return CGSize(width: cellWidth, height: cellWidth * 1.5) // 3:2 aspect ratio
    }
}

// MARK: - UISearchResultsUpdating
extension MovieGridViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != nil else { return }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch(_:)), object: searchController)
        perform(#selector(performSearch(_:)), with: searchController, afterDelay: 0.5)
    }
    
    @objc private func performSearch(_ searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            presenter.searchMovies(query: "")
            return
        }
        
        presenter.searchMovies(query: searchText)
    }
}

// MARK: - MovieGridViewProtocol
extension MovieGridViewController: MovieGridViewProtocol {
    func displayMovies(_ movies: [Movie]) {
        self.allMovies = movies
        self.filteredMovies = movies
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showLoading(false)
            self.showLoadingFooter(false)
            self.updateUI()
        }
    }
    
    func displaySearchResults(_ movies: [Movie]) {
        self.filteredMovies = movies
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showLoading(false)
            self.showLoadingFooter(false)
            self.updateUI()
        }
    }
    
    func appendMovies(_ movies: [Movie]) {
        let newMovies = movies.filter { newMovie in
            !allMovies.contains { $0.id == newMovie.id }
        }
        
        self.allMovies.append(contentsOf: newMovies)
        
        if let searchController = navigationItem.searchController,
           !searchController.isActive || searchController.searchBar.text?.isEmpty == true {
            self.filteredMovies = self.allMovies
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showLoadingFooter(false)
            self.updateUI()
        }
    }
    
    func displayError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showLoading(false)
            self.showLoadingFooter(false)
            
            let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func updateCategoryTitle(_ title: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.title = "\(title)"
        }
    }
}

