//
//  SearchPresenter.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 15/05/25.
//

import Foundation

protocol SearchPresenterProtocol {
    func searchMovie(query: String)
}

class SearchPresenter: SearchPresenterProtocol {
    weak var view: SearchViewProtocol?
    var interactor: SearchInteractorProtocol?
    var router: SearchRouterProtocol?

    func searchMovie(query: String) {
        if query.trimmingCharacters(in: .whitespaces).isEmpty {
            view?.showError(message: "Digite um nome válido.")
            return
        }
        interactor?.fetchMovies(query: query)
    }
}

extension SearchPresenter: SearchInteractorOutput {
    func didFetchMovies(_ movies: [Movie]) {
        router?.navigateToMovieList(from: view, with: movies)
    }

    func didFailToFetchMovies(with error: Error) {
        view?.showError(message: "Erro ao buscar filmes.")
    }
}
