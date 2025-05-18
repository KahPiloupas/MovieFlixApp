//
//  MovieCategory.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 17/05/25.
//

import Foundation

enum MovieCategory: String, CaseIterable {
    case all = "Todos os Filmes"
    case nowPlaying = "Em Cartaz"
    case popular = "Populares"
    case topRated = "Mais Bem Avaliados"
    case upcoming = "Próximos Lançamentos"
}
