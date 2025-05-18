//
//  MovieSearchResponse.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

struct MovieSearchResponse: Codable {
    let results: [Movie]
    let page: Int
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case results, page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
