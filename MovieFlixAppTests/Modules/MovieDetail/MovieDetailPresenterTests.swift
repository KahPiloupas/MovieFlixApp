//
//  MovieDetailPresenterTests.swift
//  MovieFlixAppTests
//
//  Created by Karina Piloupas on 18/05/25.
//

import XCTest
@testable import MovieFlixApp

class MovieDetailPresenterTests: XCTestCase {
    
    var presenter: MovieDetailPresenter!
    var mockInteractor: MockMovieDetailInteractor!
    var mockView: MockMovieDetailView!
    var mockRouter: MockMovieDetailRouter!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockMovieDetailInteractor()
        mockView = MockMovieDetailView()
        mockRouter = MockMovieDetailRouter()
        
        presenter = MovieDetailPresenter(movieId: 1)
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }
    
    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        mockView = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testViewDidLoadFetchesMovieDetail() {
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockInteractor.fetchMovieDetailCalled)
    }
    
    func testToggleFavoriteCallsInteractor() {
        let genre = Genre(id: 28, name: "Action")
        let movie = MovieDetail(
                                id: 1,
                                originalTitle: "Test Movie",
                                title: "Test Movie",
                                overview: "A movie for testing",
                                releaseDate: "2023-01-01",
                                voteAverage: 8.0, backdropPath: "/test.jpg",
                                budget: 100000,
                                revenue: 500000,
                                genres: [genre])
        
        presenter.toggleFavorite(movie)
        
        XCTAssertTrue(mockInteractor.toggleFavoriteCalled)
        XCTAssertEqual(mockInteractor.toggleFavoriteMovie?.id, movie.id)
    }
    
    func testDidFailToFetchDetailDisplaysError() {
        let error = NSError(domain: "test", code: 0, userInfo: nil)
        
        presenter.didFailToFetchDetail(with: error)
        
        XCTAssertTrue(mockView.displayErrorCalled)
    }
    
    func testDidFetchMovieDetailUpdatesView() {
        let genre = Genre(id: 28, name: "Action")
        let movie = MovieDetail(
                                id: 1,
                                originalTitle: "Test Movie",
                                title: "Test Movie",
                                overview: "A movie for testing",
                                releaseDate: "2023-01-01",
                                voteAverage: 8.0,
                                backdropPath: "/test.jpg",
                                budget: 100000,
                                revenue: 500000,
                                genres: [genre])
        
        presenter.didFetchMovieDetail(movie)
        
        XCTAssertTrue(mockView.displayMovieDetailCalled)
        XCTAssertEqual(mockView.displayedMovie?.id, movie.id)
    }
    
    func testDidUpdateFavoriteStatusUpdatesView() {
        let genre = Genre(id: 28, name: "Action")
        let movie = MovieDetail(
                                id: 1,
                                originalTitle: "Test Movie",
                                title: "Test Movie",
                                overview: "A movie for testing",
                                releaseDate: "2023-01-01",
                                voteAverage: 8.0,
                                backdropPath: "/test.jpg",
                                budget: 100000,
                                revenue: 500000,
                                genres: [genre])
        
        let isFavorite = true
        
        presenter.didUpdateFavoriteStatus(movie, isFavorite: isFavorite)
        
        XCTAssertTrue(mockView.displayMovieDetailCalled)
        XCTAssertEqual(mockView.displayedMovie?.id, movie.id)
    }
}
