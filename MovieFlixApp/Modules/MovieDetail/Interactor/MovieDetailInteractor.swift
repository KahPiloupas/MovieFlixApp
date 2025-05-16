//
//  MovieDetailInteractor.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

protocol MovieDetailInteractorProtocol {
    func fetchMovieDetail()
}

protocol MovieDetailInteractorOutput: AnyObject {
    func didFetchMovieDetail(_ detail: MovieDetail)
    func didFailToFetchDetail(with error: Error)
}

class MovieDetailInteractor: MovieDetailInteractorProtocol {
    
    let service = MovieAPIService()
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
}
