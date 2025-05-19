//
//  MovieDetail.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name: String
}

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
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, budget, revenue, genres
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case backdropPath = "backdrop_path"
    }
    
    init(id: Int, 
         originalTitle: String, 
         title: String, 
         overview: String, 
         releaseDate: String, 
         voteAverage: Double, 
         backdropPath: String?, 
         budget: Int, 
         revenue: Int, 
         genres: [Genre]) {
        self.id = id
        self.originalTitle = originalTitle
        self.title = title
        self.overview = overview
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.backdropPath = backdropPath
        self.budget = budget
        self.revenue = revenue
        self.genres = genres
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        
        overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? ""
        
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        
        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0.0
        
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        
        budget = try container.decodeIfPresent(Int.self, forKey: .budget) ?? 0
        revenue = try container.decodeIfPresent(Int.self, forKey: .revenue) ?? 0
        
        genres = try container.decodeIfPresent([Genre].self, forKey: .genres) ?? []
    }
}
