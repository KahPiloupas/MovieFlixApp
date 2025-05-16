//
//  MovieDetail.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

struct MovieDetail: Codable {
    let id: Int
    let originalTitle: String
    let title: String
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    let backdropPath: String?
    let budget: Int
    let revenue: Int

    enum CodingKeys: String, CodingKey {
        case id, title, overview, budget, revenue
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case backdropPath = "backdrop_path"
    }
}
