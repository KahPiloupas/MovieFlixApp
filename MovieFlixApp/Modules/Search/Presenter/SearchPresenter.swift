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
