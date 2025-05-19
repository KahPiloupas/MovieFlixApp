//
//  FavoritesMocks.swift
//  MovieFlixAppTests
//
//  Created by Karina Piloupas on 19/05/25.
//

import Foundation
import UIKit
@testable import MovieFlixApp

class FavoritesViewMock: FavoritesViewProtocol {
    var displayFavoritesCalled = false
    var displayedFavorites: [MovieDetail] = []
    
    func displayFavorites(_ movies: [MovieDetail]) {
        displayFavoritesCalled = true
        displayedFavorites = movies
    }
}

class FavoritesInteractorMock: FavoritesInteractorProtocol {
    var getFavoritesCalled = false
    var removeFavoriteCalled = false
    var removeFavoriteId: Int = 0
    
    func getFavorites() {
        getFavoritesCalled = true
    }
    
    func removeFavorite(id: Int) {
        removeFavoriteCalled = true
        removeFavoriteId = id
    }
}

class FavoritesRouterMock: FavoritesRouterProtocol {
    var navigateToDetailCalled = false
    var movieId: Int = 0
    var fromView: FavoritesViewProtocol?
    
    func navigateToDetail(from view: FavoritesViewProtocol?, movieId: Int) {
        navigateToDetailCalled = true
        self.movieId = movieId
        self.fromView = view
    }
} 
