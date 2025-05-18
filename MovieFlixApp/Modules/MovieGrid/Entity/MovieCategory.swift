//
//  MovieCategory.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 17/05/25.
//

import Foundation

enum MovieCategory: String, CaseIterable {
    case all = "All Movies"
    case nowPlaying = "On display"
    case popular = "Popular"
    case topRated = "Top Rated"
    case upcoming = "Upcoming Releases"
}
