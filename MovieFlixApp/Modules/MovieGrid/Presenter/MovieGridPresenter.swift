//
//  MovieGridPresenter.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 17/05/25.
//

import Foundation

protocol MovieGridPresenterProtocol {
    func viewDidLoad()
    func didSelectMovie(_ movie: Movie)
    func refreshData()
    func fetchMovieCategory(_ category: MovieCategory)
    func loadMoreMovies()
    func searchMovies(query: String)
    func toggleFavorite(for movie: Movie)
    var currentCategory: MovieCategory { get }
    var isLoadingMore: Bool { get }
    var isSearching: Bool { get }
}

class MovieGridPresenter: MovieGridPresenterProtocol {
    
    weak var view: MovieGridViewProtocol?
    var interactor: MovieGridInteractorProtocol?
    var router: MovieGridRouterProtocol?
    
    private(set) var currentCategory: MovieCategory = .all
    private(set) var currentPage: Int = 1
    private(set) var isLoadingMore: Bool = false
    private(set) var isSearching: Bool = false
    private var hasMorePages: Bool = true
    
    func viewDidLoad() {
        view?.showLoading(true)
        fetchMovieCategory(.all)
    }
    
    func refreshData() {
        view?.showLoading(true)
        currentPage = 1
        hasMorePages = true
        fetchMovieCategoryWithPage(currentCategory, page: currentPage)
    }
    
    func fetchMovieCategory(_ category: MovieCategory) {
        view?.showLoading(true)
        currentCategory = category
        currentPage = 1
        hasMorePages = true
        fetchMovieCategoryWithPage(category, page: currentPage)
    }
    
    func loadMoreMovies() {
        if isLoadingMore || !hasMorePages || isSearching {
            return
        }
        
        isLoadingMore = true
        currentPage += 1
        fetchMovieCategoryWithPage(currentCategory, page: currentPage)
    }
    
    func searchMovies(query: String) {
        if query.isEmpty {
            isSearching = false
            fetchMovieCategoryWithPage(currentCategory, page: 1)
            return
        }
        
        isSearching = true
        view?.showLoading(true)
        interactor?.searchMovies(query: query)
    }
    
    func toggleFavorite(for movie: Movie) {
        interactor?.fetchMovieDetail(id: movie.id, completion: { [weak self] result in
            switch result {
            case .success(let movieDetail):
                let favoritesManager = FavoritesManager.shared
                if favoritesManager.isFavorite(id: movie.id) {
                    favoritesManager.removeFromFavorites(id: movie.id)
                } else {
                    favoritesManager.addToFavorites(movieDetail)
                }
            case .failure:
                break
            }
        })
    }
    
    private func fetchMovieCategoryWithPage(_ category: MovieCategory, page: Int) {
        isSearching = false
        
        switch category {
        case .all:
            interactor?.fetchAllMovies(page: page)
        case .nowPlaying:
            interactor?.fetchNowPlayingMovies(page: page)
        case .popular:
            interactor?.fetchPopularMovies(page: page)
        case .topRated:
            interactor?.fetchTopRatedMovies(page: page)
        case .upcoming:
            interactor?.fetchUpcomingMovies(page: page)
        }
        
        view?.updateCategoryTitle(category.rawValue)
    }
    
    func didSelectMovie(_ movie: Movie) {
        router?.navigateToMovieDetail(from: view, with: movie.id)
    }
}

extension MovieGridPresenter: MovieGridInteractorOutput {
    func didFetchMovies(_ movies: [Movie]) {
        isLoadingMore = false
        
        if currentPage == 1 {
            if movies.isEmpty {
                hasMorePages = false
                view?.displayMovies([])
            } else {
                view?.displayMovies(movies)
            }
        } else {
            if movies.isEmpty {
                hasMorePages = false
            } else {
                view?.appendMovies(movies)
            }
        }
    }
    
    func didFailToFetchMovies(with error: Error) {
        isLoadingMore = false
        view?.displayError(error.localizedDescription)
    }
    
    func didSearchMovies(_ movies: [Movie]) {
        isLoadingMore = false
        view?.displaySearchResults(movies)
    }
}
