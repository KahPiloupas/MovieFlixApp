//
//  SearchInteractor.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 15/05/25.
//

import Foundation

protocol SearchInteractorProtocol {
    func fetchMovies(query: String)
}

class SearchInteractor: SearchInteractorProtocol {
    func fetchMovies(query: String) {
        // requisiçao da API
        print("Buscando filmes para: \(query)")
    }
}
