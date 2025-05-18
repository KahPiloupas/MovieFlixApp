//
//  MovieGridInteractor.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 17/05/25.
//

import Foundation

protocol MovieGridInteractorProtocol {
    func fetchPopularMovies(page: Int)
    func fetchAllMovies(page: Int)
    func fetchNowPlayingMovies(page: Int)
    func fetchTopRatedMovies(page: Int)
    func fetchUpcomingMovies(page: Int)
    func fetchAllCategories(page: Int)
    func searchMovies(query: String)
    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void)
}

protocol MovieGridInteractorOutput: AnyObject {
    func didFetchMovies(_ movies: [Movie])
    func didFailToFetchMovies(with error: Error)
    func didSearchMovies(_ movies: [Movie])
}

class MovieGridInteractor: MovieGridInteractorProtocol {
    
    let service = MovieAPIService()
    weak var output: MovieGridInteractorOutput?
    
    func fetchPopularMovies(page: Int = 1) {
        service.fetchPopularMovies(page: page) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.output?.didFetchMovies(movies)
            case .failure(let error):
                self?.output?.didFailToFetchMovies(with: error)
            }
        }
    }
    
    func fetchAllMovies(page: Int = 1) {
        service.fetchAllMovies(page: page) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.output?.didFetchMovies(movies)
            case .failure(let error):
                self?.output?.didFailToFetchMovies(with: error)
            }
        }
    }
    
    func fetchNowPlayingMovies(page: Int = 1) {
        service.fetchNowPlayingMovies(page: page) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.output?.didFetchMovies(movies)
            case .failure(let error):
                self?.output?.didFailToFetchMovies(with: error)
            }
        }
    }
    
    func fetchTopRatedMovies(page: Int = 1) {
        service.fetchTopRatedMovies(page: page) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.output?.didFetchMovies(movies)
            case .failure(let error):
                self?.output?.didFailToFetchMovies(with: error)
            }
        }
    }
    
    func fetchUpcomingMovies(page: Int = 1) {
        service.fetchUpcomingMovies(page: page) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.output?.didFetchMovies(movies)
            case .failure(let error):
                self?.output?.didFailToFetchMovies(with: error)
            }
        }
    }
    
    func fetchAllCategories(page: Int = 1) {
        service.fetchMoviesFromAllCategories(page: page) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.output?.didFetchMovies(movies)
            case .failure(let error):
                self?.output?.didFailToFetchMovies(with: error)
            }
        }
    }
    
    func searchMovies(query: String) {
        service.searchMovies(query: query) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.output?.didSearchMovies(movies)
            case .failure(let error):
                self?.output?.didFailToFetchMovies(with: error)
            }
        }
    }
    
    func fetchMovieDetail(id: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        service.fetchMovieDetail(id: id, completion: completion)
    }
}
