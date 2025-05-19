//
//  ContextTypeHelper.swift
//  MovieFlixAppTests
//
//  Created by Karina Piloupas on 18/05/25.
//

import Foundation
@testable import MovieFlixApp

extension Optional where Wrapped == String {
    static var nullString: String? {
        return nil
    }
}

extension MovieDetail {
    static func testInstance(
        id: Int = 100,
        originalTitle: String = "Test Movie",
        title: String = "Test Movie",
        overview: String = "Test Overview",
        releaseDate: String = "2023-01-01",
        voteAverage: Double = 8.0,
        backdropPath: String? = nil,
        budget: Int = 10000,
        revenue: Int = 50000,
        genres: [Genre] = [Genre(id: 28, name: "Action")]
    ) -> MovieDetail {
        return MovieDetail(
            id: id,
            originalTitle: originalTitle,
            title: title,
            overview: overview,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            backdropPath: backdropPath,
            budget: budget,
            revenue: revenue,
            genres: genres
        )
    }
}
