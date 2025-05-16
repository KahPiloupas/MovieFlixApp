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

protocol SearchInteractorOutput: AnyObject {
    func didFetchMovies(_ movies: [Movie])
    func didFailToFetchMovies(with error: Error)
}

class SearchInteractor: SearchInteractorProtocol {
    var service = MovieAPIService()
    weak var output: SearchInteractorOutput?
    
    func fetchMovies(query: String) {
        service.searchMovies(query: query) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.output?.didFetchMovies(movies)
            case .failure(let error):
                self?.output?.didFailToFetchMovies(with: error)
            }
        }
    }
}
