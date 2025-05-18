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
    private let favoritesManager = FavoritesManager.shared
    
    func getFavorites() {
        let favorites = favoritesManager.getAllFavorites()
        output?.didLoadFavorites(favorites)
    }
    
    func removeFavorite(id: Int) {
        favoritesManager.removeFromFavorites(id: id)
        getFavorites()
    }
}
