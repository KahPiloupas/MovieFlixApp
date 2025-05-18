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
            view?.showError(message: "Digite um nome válido.")
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
            view?.showError(message: "Nenhum filme encontrado. Tente outra busca.")
            return
        }
        router?.navigateToMovieList(from: view, with: movies)
    }

    func didFailToFetchMovies(with error: Error) {
        view?.showLoading(false)
        
        if let apiError = error as? MovieAPIService.MovieAPIError {
            switch apiError {
            case .unauthorized:
                view?.showError(message: "Chave de API inválida ou expirada. Contate o desenvolvedor.")
            case .httpError(let code):
                view?.showError(message: "Erro no servidor (\(code)). Tente novamente mais tarde.")
            case .apiError(let message):
                view?.showError(message: "Erro na API: \(message)")
            default:
                view?.showError(message: apiError.localizedDescription)
            }
        } else {
            view?.showError(message: "Erro ao buscar filmes. Verifique sua conexão e tente novamente.")
        }
    }
}
