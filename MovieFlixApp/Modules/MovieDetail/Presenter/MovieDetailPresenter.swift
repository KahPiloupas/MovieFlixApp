//
//  MovieDetailPresenter.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

protocol MovieDetailPresenterProtocol {
    func viewDidLoad()
    func toggleFavorite(_ movie: MovieDetail)
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
    
    func toggleFavorite(_ movie: MovieDetail) {
        interactor?.toggleFavorite(movie)
    }
}

extension MovieDetailPresenter: MovieDetailInteractorOutput {
    func didFetchMovieDetail(_ detail: MovieDetail) {
        view?.displayMovieDetail(detail)
    }
    
    func didFailToFetchDetail(with error: Error) {
        view?.displayError("Erro ao carregar detalhes.")
    }
    
    func didUpdateFavoriteStatus(_ movie: MovieDetail, isFavorite: Bool) {
        view?.displayMovieDetail(movie)
    }
}
