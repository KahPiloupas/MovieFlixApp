//
//  SearchPresenter.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 15/05/25.
//

import Foundation

protocol SearchPresenterProtocol {
    func searchMovie(query: String)
    func showAllMovies()
}

class SearchPresenter: SearchPresenterProtocol {
    weak var view: SearchViewProtocol?
    var interactor: SearchInteractorProtocol?
    var router: SearchRouterProtocol?
    
    func searchMovie(query: String) {
        if query.trimmingCharacters(in: .whitespaces).isEmpty {
            view?.showError(message: "Enter a valid name.")
            return
        }
        view?.showLoading(true)
        interactor?.fetchMovies(query: query)
    }
    
    func showAllMovies() {
        router?.navigateToMovieGrid(from: view)
    }
}

extension SearchPresenter: SearchInteractorOutput {
    func didFetchMovies(_ movies: [Movie]) {
        view?.showLoading(false)
        if movies.isEmpty {
            view?.showError(message: "No movies found. Try another search.")
            return
        }
        router?.navigateToMovieList(from: view, with: movies)
    }
    
    func didFailToFetchMovies(with error: Error) {
        view?.showLoading(false)
        
        if let apiError = error as? MovieAPIService.MovieAPIError {
            switch apiError {
            case .unauthorized:
                view?.showError(message: "Invalid or expired API key. Contact the developer.")
            case .httpError(let code):
                view?.showError(message: "Server error (\(code)). Please try again later.")
            case .apiError(let message):
                view?.showError(message: "API Error: \(message)")
            default:
                view?.showError(message: apiError.localizedDescription)
            }
        } else {
            view?.showError(message: "Error fetching movies. Check your connection and try again.")
        }
    }
}
