//
//  MovieModelTests.swift
//  MovieFlixAppTests
//
//  Created by Karina Piloupas on 18/05/25.
//

import XCTest
@testable import MovieFlixApp

class MovieModelTests: XCTestCase {
    
    func testMovieInitWithDecoder() throws {
        let json = """
        {
            "id": 12345,
            "original_title": "Test Movie",
            "poster_path": "/path/to/poster.jpg",
            "vote_average": 8.5
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let movie = try decoder.decode(Movie.self, from: json)
        
        XCTAssertEqual(movie.id, 12345)
        XCTAssertEqual(movie.originalTitle, "Test Movie")
        XCTAssertEqual(movie.posterPath, "/path/to/poster.jpg")
        XCTAssertEqual(movie.voteAverage, 8.5)
    }
    
    func testMovieInitWithOptionalFields() throws {
        let json = """
        {
            "id": 12345,
            "original_title": "Test Movie",
            "vote_average": 0
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let movie = try decoder.decode(Movie.self, from: json)
        
        XCTAssertEqual(movie.id, 12345)
        XCTAssertEqual(movie.originalTitle, "Test Movie")
        XCTAssertNil(movie.posterPath)
        XCTAssertEqual(movie.voteAverage, 0)
    }
    
    func testMovieInitWithParameters() {
        let movie = Movie(id: 100, originalTitle: "Created Movie", posterPath: "/some/path.jpg", voteAverage: 7.5)
        
        XCTAssertEqual(movie.id, 100)
        XCTAssertEqual(movie.originalTitle, "Created Movie")
        XCTAssertEqual(movie.posterPath, "/some/path.jpg")
        XCTAssertEqual(movie.voteAverage, 7.5)
    }
}
