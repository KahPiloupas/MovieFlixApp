//
//  FavoritesInteractor.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

protocol FavoritesInteractorProtocol {
    func getFavorites()
    func removeFavorite(id: Int)
}

protocol FavoritesInteractorOutput: AnyObject {
    func didLoadFavorites(_ movies: [MovieDetail])
}

class FavoritesInteractor: FavoritesInteractorProtocol {
    weak var output: FavoritesInteractorOutput?

    func getFavorites() {
        let favorites = FavoritesManager.shared.fetchFavorites()
        output?.didLoadFavorites(favorites)
    }

    func removeFavorite(id: Int) {
        FavoritesManager.shared.removeFavorite(id: id)
        getFavorites()
    }
}
