//
//  MovieGridPresenterTests.swift
//  MovieFlixAppTests
//
//  Created by Karina Piloupas on 18/05/25.
//

import XCTest
@testable import MovieFlixApp

class MovieGridPresenterTests: XCTestCase {
    
    var presenter: MovieGridPresenter!
    var mockInteractor: MockMovieGridInteractor!
    var mockRouter: MockMovieGridRouter!
    var mockView: MockMovieGridView!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockMovieGridInteractor()
        mockRouter = MockMovieGridRouter()
        mockView = MockMovieGridView()
        
        presenter = MovieGridPresenter()
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        mockRouter = nil
        mockView = nil
        super.tearDown()
    }
    
    func testViewDidLoadFetchesPopularMovies() {
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockInteractor.fetchAllMoviesCalled)
        XCTAssertEqual(mockInteractor.fetchPage, 1)
    }
    
    func testRefreshDataResetsPage() {
        presenter.setCurrentPage(3)
        presenter.setIsLoadingMore(true)
        
        presenter.refreshData()
        
        XCTAssertEqual(presenter.currentPage, 1)
        XCTAssertFalse(presenter.isLoadingMore)
        XCTAssertTrue(mockInteractor.fetchAllMoviesCalled)
    }
    
    func testFetchMovieCategory() {
        let categories: [MovieCategory] = [.popular, .topRated, .nowPlaying, .upcoming, .all]
        
        for category in categories {
            mockInteractor.reset()
            presenter.setCurrentPage(1)
            
            presenter.fetchMovieCategory(category)
            
            switch category {
            case .popular:
                XCTAssertTrue(mockInteractor.fetchPopularMoviesCalled)
            case .topRated:
                XCTAssertTrue(mockInteractor.fetchTopRatedMoviesCalled)
            case .nowPlaying:
                XCTAssertTrue(mockInteractor.fetchNowPlayingMoviesCalled)
            case .upcoming:
                XCTAssertTrue(mockInteractor.fetchUpcomingMoviesCalled)
            case .all:
                XCTAssertTrue(mockInteractor.fetchAllMoviesCalled)
            }
            
            XCTAssertEqual(presenter.currentCategory, category)
        }
    }
    
    func testLoadMoreMovies() {
        presenter.setCurrentPage(1)
        presenter.setIsLoadingMore(false)
        presenter.setCurrentCategory(.popular)
        
        presenter.loadMoreMovies()
        
        XCTAssertEqual(presenter.currentPage, 2)
        XCTAssertTrue(presenter.isLoadingMore)
        XCTAssertTrue(mockInteractor.fetchPopularMoviesCalled)
        XCTAssertEqual(mockInteractor.fetchPage, 2)
    }
    
    func testSearchMovies() {
        presenter.searchMovies(query: "test")
        
        XCTAssertTrue(mockInteractor.searchMoviesCalled)
        XCTAssertEqual(mockInteractor.searchQuery, "test")
        XCTAssertTrue(presenter.isSearching)
    }
    
    func testDidSelectMovie() {
        let movie = Movie(id: 1, originalTitle: "Test Movie", posterPath: "/test.jpg", voteAverage: 8.0)
        
        presenter.didSelectMovie(movie)
        
        XCTAssertTrue(mockRouter.navigateToMovieDetailCalled)
        XCTAssertEqual(mockRouter.selectedMovieId, movie.id)
        XCTAssertEqual(mockRouter.fromView as? MockMovieGridView, mockView)
    }
    
    func testToggleFavorite() {
        let movie = Movie(id: 1, originalTitle: "Test Movie", posterPath: "/test.jpg", voteAverage: 8.0)
        
        presenter.toggleFavorite(for: movie)
        
        XCTAssertTrue(mockInteractor.fetchMovieDetailCalled)
        XCTAssertEqual(mockInteractor.fetchMovieDetailId, movie.id)
    }
    
    func testDidFetchMoviesUpdatesView() {
        let movies = [
            Movie(id: 1, originalTitle: "Movie 1", posterPath: "/path1.jpg", voteAverage: 7.5),
            Movie(id: 2, originalTitle: "Movie 2", posterPath: "/path2.jpg", voteAverage: 8.0)
        ]
        
        presenter.setIsLoadingMore(true)
        
        presenter.didFetchMovies(movies)
        
        XCTAssertTrue(mockView.displayMoviesCalled)
        XCTAssertEqual(mockView.displayedMovies.count, 2)
        XCTAssertFalse(presenter.isLoadingMore)
    }
    
    func testDidFailToFetchMoviesDisplaysError() {
        let error = NSError(domain: "test", code: 0, userInfo: nil)
        
        presenter.setIsLoadingMore(true)
        
        presenter.didFailToFetchMovies(with: error)
        
        XCTAssertTrue(mockView.displayErrorCalled)
        XCTAssertFalse(presenter.isLoadingMore)
    }
    
    func testDidSearchMoviesUpdatesView() {
        let movies = [
            Movie(id: 1, originalTitle: "Movie 1", posterPath: "/path1.jpg", voteAverage: 7.5),
            Movie(id: 2, originalTitle: "Movie 2", posterPath: "/path2.jpg", voteAverage: 8.0)
        ]
        
        presenter.didSearchMovies(movies)
        
        XCTAssertTrue(mockView.displaySearchResultsCalled)
        XCTAssertEqual(mockView.displayedSearchResults.count, 2)
    }
}
