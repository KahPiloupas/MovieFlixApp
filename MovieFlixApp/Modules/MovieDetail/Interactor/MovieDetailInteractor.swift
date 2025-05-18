//
//  MovieDetailInteractor.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

protocol MovieDetailInteractorProtocol {
    func fetchMovieDetail()
    func toggleFavorite(_ movie: MovieDetail)
}

protocol MovieDetailInteractorOutput: AnyObject {
    func didFetchMovieDetail(_ detail: MovieDetail)
    func didFailToFetchDetail(with error: Error)
    func didUpdateFavoriteStatus(_ movie: MovieDetail, isFavorite: Bool)
}

class MovieDetailInteractor: MovieDetailInteractorProtocol {
    
    let service = MovieAPIService()
    let favoritesManager = FavoritesManager.shared
    let movieId: Int
    weak var output: MovieDetailInteractorOutput?
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    func fetchMovieDetail() {
        service.fetchMovieDetail(id: movieId) { [weak self] result in
            switch result {
            case .success(let detail):
                self?.output?.didFetchMovieDetail(detail)
            case .failure(let error):
                self?.output?.didFailToFetchDetail(with: error)
            }
        }
    }
    
    func toggleFavorite(_ movie: MovieDetail) {
        let isFavorite = favoritesManager.isFavorite(id: movie.id)
        
        if isFavorite {
            favoritesManager.removeFromFavorites(id: movie.id)
        } else {
            favoritesManager.addToFavorites(movie)
        }
        
        output?.didUpdateFavoriteStatus(movie, isFavorite: !isFavorite)
    }
}
