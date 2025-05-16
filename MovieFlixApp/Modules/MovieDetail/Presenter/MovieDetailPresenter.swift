//
//  MovieDetailPresenter.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

protocol MovieDetailPresenterProtocol {
    func viewDidLoad()
}

class MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    weak var view: MovieDetailViewProtocol?
    var interactor: MovieDetailInteractorProtocol?
    var router: MovieDetailRouterProtocol?
    let movieId: Int

    init(movieId: Int) {
        self.movieId = movieId
    }

    func viewDidLoad() {
        interactor?.fetchMovieDetail()
    }
}

extension MovieDetailPresenter: MovieDetailInteractorOutput {
    func didFetchMovieDetail(_ detail: MovieDetail) {
        view?.displayMovieDetail(detail)
    }

    func didFailToFetchDetail(with error: Error) {
        view?.displayError("Erro ao carregar detalhes.")
    }
}
