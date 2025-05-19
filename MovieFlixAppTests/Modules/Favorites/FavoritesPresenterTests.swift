//
//  FavoritesPresenterTests.swift
//  MovieFlixAppTests
//
//  Created by Karina Piloupas on 18/05/25.
//

import XCTest
@testable import MovieFlixApp

class FavoritesPresenterTests: XCTestCase {
    
    var presenter: FavoritesPresenter!
    var mockView: FavoritesViewMock!
    var mockInteractor: FavoritesInteractorMock!
    var mockRouter: FavoritesRouterMock!
    
    override func setUp() {
        super.setUp()
        mockView = FavoritesViewMock()
        mockInteractor = FavoritesInteractorMock()
        mockRouter = FavoritesRouterMock()
        
        presenter = FavoritesPresenter()
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testViewDidLoadCallsInteractor() {
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockInteractor.getFavoritesCalled)
    }
    
    func testDidTapRemoveCallsInteractor() {
        let movieId = 100
        
        presenter.didTapRemove(id: movieId)
        
        XCTAssertTrue(mockInteractor.removeFavoriteCalled)
        XCTAssertEqual(mockInteractor.removeFavoriteId, movieId)
    }
    
    func testDidSelectMovieCallsRouter() {
        let movieId = 200
        
        presenter.didSelectMovie(id: movieId)
        
        XCTAssertTrue(mockRouter.navigateToDetailCalled)
        XCTAssertEqual(mockRouter.movieId, movieId)
    }
    
    func testDidLoadFavoritesUpdatesView() {
        let genre = Genre(id: 28, name: "Action")
        let movies = [
            MovieDetail(id: 101,
                       originalTitle: "Movie 1",
                       title: "Movie 1",
                       overview: "Overview 1",
                       releaseDate: "2023-01-01",
                       voteAverage: 7.5,
                       backdropPath: "/path1.jpg",
                       budget: 1000000,
                       revenue: 5000000,
                       genres: [genre]),
            MovieDetail(id: 102,
                       originalTitle: "Movie 2",
                       title: "Movie 2",
                       overview: "Overview 2",
                       releaseDate: "2023-02-01",
                       voteAverage: 8.0,
                       backdropPath: "/path2.jpg",
                       budget: 2000000,
                       revenue: 8000000,
                       genres: [genre])
        ]
        
        presenter.didLoadFavorites(movies)
        
        XCTAssertTrue(mockView.displayFavoritesCalled)
        XCTAssertEqual(mockView.displayedFavorites.count, 2)
    }
}
