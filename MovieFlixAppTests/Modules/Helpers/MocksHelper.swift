//
//  MocksHelper.swift
//  MovieFlixAppTests
//
//  Created by Karina Piloupas on 18/05/25.
//

import Foundation
import UIKit
@testable import MovieFlixApp

// MARK: - Movie Grid Mocks
class MockMovieGridInteractor: MovieGridInteractorProtocol {
    var fetchPopularMoviesCalled = false
    var fetchAllMoviesCalled = false
    var fetchNowPlayingMoviesCalled = false
    var fetchTopRatedMoviesCalled = false
    var fetchUpcomingMoviesCalled = false
    var fetchAllCategoriesCalled = false
    var searchMoviesCalled = false
    var fetchMovieDetailCalled = false
    
    var fetchPage: Int = 0
    var searchQuery: String = ""
    var fetchMovieDetailId: Int = 0
    
    func reset() {
        fetchPopularMoviesCalled = false
        fetchAllMoviesCalled = false
        fetchNowPlayingMoviesCalled = false
        fetchTopRatedMoviesCalled = false
        fetchUpcomingMoviesCalled = false
        fetchAllCategoriesCalled = false
        searchMoviesCalled = false
        fetchMovieDetailCalled = false
        fetchPage = 0
        searchQuery = ""
        fetchMovieDetailId = 0
    }
    
    func fetchPopularMovies(page: Int) {
        fetchPopularMoviesCalled = true
        fetchPage = page
    }
    
    func fetchAllMovies(page: Int) {
        fetchAllMoviesCalled = true
        fetchPage = page
    }
    
    func fetchNowPlayingMovies(page: Int) {
        fetchNowPlayingMoviesCalled = true
        fetchPage = page
    }
    
    func fetchTopRatedMovies(page: Int) {
        fetchTopRatedMoviesCalled = true
        fetchPage = page
    }
    
    func fetchUpcomingMovies(page: Int) {
        fetchUpcomingMoviesCalled = true
        fetchPage = page
    }
    
    func fetchAllCategories(page: Int) {
        fetchAllCategoriesCalled = true
        fetchPage = page
    }
    
    func searchMovies(query: String) {
        searchMoviesCalled = true
        searchQuery = query
    }
    
    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        fetchMovieDetailCalled = true
        fetchMovieDetailId = id
        
        let genre = Genre(id: 28, name: "Action")
        let movieDetail = MovieDetail(id: id,
                                      originalTitle: "Test Movie",
                                      title: "Test Movie",
                                      overview: "Test overview",
                                      releaseDate: "2023-01-01",
                                      voteAverage: 8.0,
                                      backdropPath: "/test.jpg",
                                      budget: 100000,
                                      revenue: 500000,
                                      genres: [genre])
        
        DispatchQueue.main.async {
            completion(.success(movieDetail))
        }
    }
}

class MockMovieGridRouter: MovieGridRouterProtocol {
    var navigateToMovieDetailCalled = false
    var selectedMovieId: Int = 0
    var fromView: MovieGridViewProtocol?
    
    func navigateToMovieDetail(from view: MovieGridViewProtocol?, with movieId: Int) {
        navigateToMovieDetailCalled = true
        selectedMovieId = movieId
        fromView = view
    }
}

class MockMovieGridView: MovieGridViewProtocol, Equatable {
    var displayMoviesCalled = false
    var displayedMovies: [Movie] = []
    var displayErrorCalled = false
    var displayedError: String?
    var appendMoviesCalled = false
    var appendedMovies: [Movie] = []
    var displaySearchResultsCalled = false
    var displayedSearchResults: [Movie] = []
    var showLoadingCalled = false
    var isLoading = false
    var updateCategoryTitleCalled = false
    var categoryTitle: String?
    
    func displayMovies(_ movies: [Movie]) {
        displayMoviesCalled = true
        displayedMovies = movies
    }
    
    func displayError(_ message: String) {
        displayErrorCalled = true
        displayedError = message
    }
    
    func appendMovies(_ movies: [Movie]) {
        appendMoviesCalled = true
        appendedMovies = movies
    }
    
    func displaySearchResults(_ movies: [Movie]) {
        displaySearchResultsCalled = true
        displayedSearchResults = movies
    }
    
    func showLoading(_ isLoading: Bool) {
        showLoadingCalled = true
        self.isLoading = isLoading
    }
    
    func updateCategoryTitle(_ title: String) {
        updateCategoryTitleCalled = true
        categoryTitle = title
    }
    
    static func == (lhs: MockMovieGridView, rhs: MockMovieGridView) -> Bool {
        return lhs === rhs
    }
}

// MARK: - Movie Detail Mocks
class MockMovieDetailInteractor: MovieDetailInteractorProtocol {
    var fetchMovieDetailCalled = false
    var toggleFavoriteCalled = false
    var toggleFavoriteMovie: MovieDetail?
    
    func fetchMovieDetail() {
        fetchMovieDetailCalled = true
    }
    
    func toggleFavorite(_ movie: MovieDetail) {
        toggleFavoriteCalled = true
        toggleFavoriteMovie = movie
    }
}

class MockMovieDetailView: MovieDetailViewProtocol {
    var displayMovieDetailCalled = false
    var displayedMovie: MovieDetail?
    var displayErrorCalled = false
    var displayedError: String?
    
    func displayMovieDetail(_ detail: MovieDetail) {
        displayMovieDetailCalled = true
        displayedMovie = detail
    }
    
    func displayError(_ message: String) {
        displayErrorCalled = true
        displayedError = message
    }
}

class MockMovieDetailRouter: MovieDetailRouterProtocol {
    var navigateBackCalled = false
    
    func navigateBack() {
        navigateBackCalled = true
    }
    
    static func createModule(with movieId: Int) -> UIViewController {
        return UIViewController()
    }
}
