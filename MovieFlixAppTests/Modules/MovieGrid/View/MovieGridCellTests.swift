//
//  MovieGridCellTests.swift
//  MovieFlixAppTests
//
//  Created by Karina Piloupas on 18/05/25.
//

import XCTest
@testable import MovieFlixApp

class MovieGridCellTests: XCTestCase {
    
    var cell: MovieGridCell!
    
    override func setUp() {
        super.setUp()
        cell = MovieGridCell(frame: CGRect(x: 0, y: 0, width: 150, height: 250))
    }
    
    override func tearDown() {
        cell = nil
        super.tearDown()
    }
    
    func testCellInitialization() {
        XCTAssertNotNil(cell, "Cell should be created successfully")
        XCTAssertEqual(cell.frame.width, 150)
        XCTAssertEqual(cell.frame.height, 250)
    }
    
    func testConfigureWithMovie() {
        let movie = Movie(id: 100, originalTitle: "Test Movie", posterPath: "/poster/path.jpg", voteAverage: 8.5)
        
        FavoritesManager.shared.addToFavorites(MovieDetail(
            id: 100,
            originalTitle: "Test Movie",
            title: "Test Movie",
            overview: "Overview",
            releaseDate: "2023-01-01",
            voteAverage: 8.5,
            backdropPath: nil,
            budget: 0,
            revenue: 0,
            genres: []
        ))
        
        cell.configure(with: movie)
        
        XCTAssertNotNil(cell.contentView, "Content view should exist")
        
        FavoritesManager.shared.removeFromFavorites(id: 100)
    }
    
    func testConfigureWithNonFavoriteMovie() {
        let movie = Movie(id: 200, originalTitle: "Non-Favorite Movie", posterPath: "/poster/path.jpg", voteAverage: 7.0)
        
        FavoritesManager.shared.removeFromFavorites(id: 200)
        
        cell.configure(with: movie)
        
        XCTAssertNotNil(cell.contentView, "Content view should exist")
    }
    
    func testPrepareForReuse() {
        let movie = Movie(id: 100, originalTitle: "Test Movie", posterPath: "/poster/path.jpg", voteAverage: 8.5)
        cell.configure(with: movie)
        
        cell.prepareForReuse()
        
        XCTAssertNotNil(cell.contentView, "Content view should exist after reuse")
    }
    
    func testFavoriteAction() {
        var actionCalled = false
        cell.favoriteAction = {
            actionCalled = true
        }
        
        cell.triggerFavoriteAction(from: nil)
        
        XCTAssertTrue(actionCalled, "Favorite action should be called")
    }
}
