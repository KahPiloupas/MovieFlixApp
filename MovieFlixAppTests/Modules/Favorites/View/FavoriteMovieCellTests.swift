//
//  FavoriteMovieCellTests.swift
//  MovieFlixAppTests
//
//  Created by Karina Piloupas on 18/05/25.
//

import XCTest
@testable import MovieFlixApp

class FavoriteMovieCellTests: XCTestCase {
    
    var cell: FavoriteMovieCell!
    
    override func setUp() {
        super.setUp()
        cell = FavoriteMovieCell(style: .default, reuseIdentifier: "FavoriteMovieCell")
    }
    
    override func tearDown() {
        cell = nil
        super.tearDown()
    }
    
    func testCellInitialization() {
        XCTAssertNotNil(cell, "Cell should be created successfully")
        XCTAssertEqual(cell.reuseIdentifier, "FavoriteMovieCell")
    }
    
    func testConfigureWithMovie() {
        let genre1 = Genre(id: 28, name: "Action")
        let genre2 = Genre(id: 12, name: "Adventure")
        let movie = MovieDetail(
            id: 100,
            originalTitle: "Test Movie",
            title: "Test Movie Localized",
            overview: "Overview",
            releaseDate: "2023-01-01",
            voteAverage: 8.5,
            backdropPath: "/backdrop/path.jpg",
            budget: 10000000,
            revenue: 50000000,
            genres: [genre1, genre2]
        )
        
        cell.configure(with: movie)
        
        XCTAssertNotNil(cell.contentView, "Content view should exist")
        XCTAssertEqual(cell.getTitleLabelText(), "Test Movie Localized", "Should use localized title since original title is shorter")
        XCTAssertEqual(cell.getGenreValueLabelText(), "Action, Adventure", "Genres should be comma-separated")
    }
    
    func testConfigureWithMovieNoGenres() {
        let movie = MovieDetail(
            id: 101,
            originalTitle: "No Genres Movie",
            title: "No Genres Movie",
            overview: "Overview",
            releaseDate: "2023-01-01",
            voteAverage: 8.5,
            backdropPath: "/backdrop/path.jpg",
            budget: 10000000,
            revenue: 50000000,
            genres: []
        )
        
        cell.configure(with: movie)
        
        XCTAssertEqual(cell.getGenreValueLabelText(), "Not available", "Should show 'Not available' for empty genres")
    }
    
    func testFavoriteButtonAction() {
        let genre = Genre(id: 28, name: "Action")
        let movie = MovieDetail(
            id: 100,
            originalTitle: "Test Movie",
            title: "Test Movie",
            overview: "Overview",
            releaseDate: "2023-01-01",
            voteAverage: 8.5,
            backdropPath: "/backdrop/path.jpg",
            budget: 10000000,
            revenue: 50000000,
            genres: [genre]
        )
        
        cell.configure(with: movie)
        
        var actionCalled = false
        var capturedId = 0
        cell.favoriteAction = { movieId in
            actionCalled = true
            capturedId = movieId
        }
        
        cell.triggerFavoriteAction(from: nil)
        
        XCTAssertTrue(actionCalled, "Favorite action should be called")
        XCTAssertEqual(capturedId, 100, "Movie ID should match")
    }
    
    func testPrepareForReuse() {
        let genre = Genre(id: 28, name: "Action")
        let movie = MovieDetail(
            id: 100,
            originalTitle: "Test Movie",
            title: "Test Movie",
            overview: "Overview",
            releaseDate: "2023-01-01",
            voteAverage: 8.5,
            backdropPath: "/backdrop/path.jpg",
            budget: 10000000,
            revenue: 50000000,
            genres: [genre]
        )
        cell.configure(with: movie)
        
        var actionCalled = false
        cell.favoriteAction = { _ in
            actionCalled = true
        }
        
        cell.prepareForReuse()
        
        XCTAssertNotNil(cell.contentView, "Content view should exist after reuse")
        XCTAssertNil(cell.getTitleLabelText(), "Title should be nil after reuse")
        XCTAssertNil(cell.getGenreValueLabelText(), "Genre value should be nil after reuse")
    }
}
