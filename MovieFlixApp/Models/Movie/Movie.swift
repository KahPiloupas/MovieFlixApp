//
//  Movie.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let originalTitle: String
    let posterPath: String?
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
    
    init(id: Int, originalTitle: String, posterPath: String?, voteAverage: Double) {
        self.id = id
        self.originalTitle = originalTitle
        self.posterPath = posterPath
        self.voteAverage = voteAverage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0.0
    }
}
