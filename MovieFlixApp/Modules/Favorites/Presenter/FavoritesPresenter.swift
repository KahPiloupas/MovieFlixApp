//
//  FavoritesPresenter.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

protocol FavoritesPresenterProtocol {
    func viewDidLoad()
    func didTapRemove(id: Int)
    func didSelectMovie(id: Int)
}

class FavoritesPresenter: FavoritesPresenterProtocol {
    
    weak var view: FavoritesViewProtocol?
    var interactor: FavoritesInteractorProtocol?
    var router: FavoritesRouterProtocol?

    func viewDidLoad() {
        interactor?.getFavorites()
    }

    func didTapRemove(id: Int) {
        interactor?.removeFavorite(id: id)
    }

    func didSelectMovie(id: Int) {
        router?.navigateToDetail(from: view, movieId: id)
    }
}

extension FavoritesPresenter: FavoritesInteractorOutput {
    func didLoadFavorites(_ movies: [MovieDetail]) {
        view?.displayFavorites(movies)
    }
}
