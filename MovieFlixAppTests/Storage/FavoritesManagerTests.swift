//
//  FavoritesManagerTests.swift
//  MovieFlixAppTests
//
//  Created by Karina Piloupas on 18/05/25.
//

import XCTest
@testable import MovieFlixApp

class FavoritesManagerTests: XCTestCase {
    
    var favoritesManager: FavoritesManager!
    var testMovie: MovieDetail!
    let testFavoritesKey = "testFavoriteMovies"
    
    override func setUp() {
        super.setUp()
        
        UserDefaults.standard.removeObject(forKey: "favoriteMovies")
        
        favoritesManager = FavoritesManager.shared
        
        favoritesManager.clearFavorites()
        
        let genre = Genre(id: 28, name: "Action")
        testMovie = MovieDetail(id: 1000,
                                originalTitle: "Test Movie",
                                title: "Test Movie",
                                overview: "A movie for testing",
                                releaseDate: "2023-01-01",
                                voteAverage: 8.0,
                                backdropPath: "/test/path.jpg",
                                budget: 10000,
                                revenue: 50000,
                                genres: [genre])
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "favoriteMovies")
        favoritesManager = nil
        testMovie = nil
        super.tearDown()
    }
    
    func testAddToFavorites() {
        favoritesManager.addToFavorites(testMovie)
        
        XCTAssertTrue(favoritesManager.isFavorite(id: testMovie.id))
        XCTAssertEqual(favoritesManager.getAllFavorites().count, 1)
    }
    
    func testRemoveFromFavorites() {
        favoritesManager.addToFavorites(testMovie)
        XCTAssertTrue(favoritesManager.isFavorite(id: testMovie.id))
        
        favoritesManager.removeFromFavorites(id: testMovie.id)
        
        XCTAssertFalse(favoritesManager.isFavorite(id: testMovie.id))
        XCTAssertEqual(favoritesManager.getAllFavorites().count, 0)
    }
    
    func testToggleFavorite() {
        let result1 = favoritesManager.toggleFavorite(testMovie)
        XCTAssertTrue(result1)
        XCTAssertTrue(favoritesManager.isFavorite(id: testMovie.id))
        
        let result2 = favoritesManager.toggleFavorite(testMovie)
        XCTAssertFalse(result2)
        XCTAssertFalse(favoritesManager.isFavorite(id: testMovie.id))
    }
    
    func testGetAllFavorites() {
        let genre = Genre(id: 28, name: "Action")
        let movie1 = MovieDetail(id: 1001,
                                originalTitle: "Movie 1",
                                title: "Movie 1",
                                overview: "",
                                releaseDate: "",
                                voteAverage: 7.0,
                                backdropPath: nil as String?,
                                budget: 0,
                                revenue: 0,
                                genres: [genre])
        
        let movie2 = MovieDetail(id: 1002,
                                originalTitle: "Movie 2",
                                title: "Movie 2",
                                overview: "",
                                releaseDate: "",
                                voteAverage: 8.0,
                                backdropPath: nil as String?,
                                budget: 0,
                                revenue: 0,
                                genres: [genre])
        
        favoritesManager.addToFavorites(movie1)
        favoritesManager.addToFavorites(movie2)
        
        let allFavorites = favoritesManager.getAllFavorites()
        
        XCTAssertEqual(allFavorites.count, 2)
        XCTAssertTrue(allFavorites.contains { $0.id == 1001 })
        XCTAssertTrue(allFavorites.contains { $0.id == 1002 })
    }
    
    func testIsFavorite() {
        XCTAssertFalse(favoritesManager.isFavorite(id: testMovie.id))
        
        favoritesManager.addToFavorites(testMovie)
        
        XCTAssertTrue(favoritesManager.isFavorite(id: testMovie.id))
    }
    
    func testNotificationOnFavoriteChange() {
        let expectation = XCTNSNotificationExpectation(name: .favoritesChanged)
        
        favoritesManager.addToFavorites(testMovie)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
