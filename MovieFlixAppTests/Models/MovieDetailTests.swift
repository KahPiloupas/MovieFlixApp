//
//  MovieDetailTests.swift
//  MovieFlixAppTests
//
//  Created by Karina Piloupas on 18/05/25.
//

import XCTest
@testable import MovieFlixApp

class MovieDetailTests: XCTestCase {
    
    func testMovieDetailDecoding() throws {
        let json = """
        {
            "id": 12345,
            "original_title": "Test Movie",
            "title": "Test Movie Localized",
            "overview": "This is a test movie description",
            "release_date": "2023-07-15",
            "vote_average": 8.5,
            "backdrop_path": "/backdrop/path.jpg",
            "budget": 100000000,
            "revenue": 300000000,
            "genres": [
                {"id": 28, "name": "Action"},
                {"id": 12, "name": "Adventure"}
            ]
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let movieDetail = try decoder.decode(MovieDetail.self, from: json)
        
        XCTAssertEqual(movieDetail.id, 12345)
        XCTAssertEqual(movieDetail.originalTitle, "Test Movie")
        XCTAssertEqual(movieDetail.title, "Test Movie Localized")
        XCTAssertEqual(movieDetail.overview, "This is a test movie description")
        XCTAssertEqual(movieDetail.releaseDate, "2023-07-15")
        XCTAssertEqual(movieDetail.voteAverage, 8.5)
        XCTAssertEqual(movieDetail.backdropPath, "/backdrop/path.jpg")
        XCTAssertEqual(movieDetail.budget, 100000000)
        XCTAssertEqual(movieDetail.revenue, 300000000)
        
        XCTAssertEqual(movieDetail.genres.count, 2)
        XCTAssertEqual(movieDetail.genres[0].id, 28)
        XCTAssertEqual(movieDetail.genres[0].name, "Action")
        XCTAssertEqual(movieDetail.genres[1].id, 12)
        XCTAssertEqual(movieDetail.genres[1].name, "Adventure")
    }
    
    func testMovieDetailWithMissingOptionalFields() throws {
        let json = """
        {
            "id": 12345,
            "original_title": "Test Movie",
            "title": "Test Movie Localized",
            "overview": "",
            "release_date": "",
            "vote_average": 0,
            "budget": 0,
            "revenue": 0,
            "genres": []
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let movieDetail = try decoder.decode(MovieDetail.self, from: json)
        
        XCTAssertEqual(movieDetail.id, 12345)
        XCTAssertEqual(movieDetail.originalTitle, "Test Movie")
        XCTAssertEqual(movieDetail.title, "Test Movie Localized")
        XCTAssertEqual(movieDetail.overview, "")
        XCTAssertEqual(movieDetail.releaseDate, "")
        XCTAssertEqual(movieDetail.voteAverage, 0)
        XCTAssertNil(movieDetail.backdropPath)
        XCTAssertEqual(movieDetail.budget, 0)
        XCTAssertEqual(movieDetail.revenue, 0)
        XCTAssertTrue(movieDetail.genres.isEmpty)
    }
    
    func testGenreDecoding() throws {
        let json = """
        {
            "id": 28,
            "name": "Action"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let genre = try decoder.decode(Genre.self, from: json)
        
        XCTAssertEqual(genre.id, 28)
        XCTAssertEqual(genre.name, "Action")
    }
}
