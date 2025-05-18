//
//  FavoritesManager.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

class FavoritesManager {
    
    // MARK: - Singleton
    static let shared = FavoritesManager()
    
    private init() {
        loadFavorites()
    }
    
    // MARK: - Properties
    private var favorites: [Int: MovieDetail] = [:]
    private let favoritesKey = "favoriteMovies"
    
    // MARK: - Public Methods
    func addToFavorites(_ movie: MovieDetail) {
        favorites[movie.id] = movie
        saveFavorites()
        NotificationCenter.default.post(name: .favoritesChanged, object: nil)
    }
    
    func removeFromFavorites(id: Int) {
        favorites.removeValue(forKey: id)
        saveFavorites()
        NotificationCenter.default.post(name: .favoritesChanged, object: nil)
    }
    
    @discardableResult
    func toggleFavorite(_ movie: MovieDetail) -> Bool {
        if isFavorite(id: movie.id) {
            removeFromFavorites(id: movie.id)
            return false
        } else {
            addToFavorites(movie)
            return true
        }
    }
    
    func isFavorite(id: Int) -> Bool {
        return favorites[id] != nil
    }
    
    func getAllFavorites() -> [MovieDetail] {
        return Array(favorites.values)
    }
    
    // MARK: - Private Methods
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(Array(favorites.values)) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let movies = try? JSONDecoder().decode([MovieDetail].self, from: data) else {
            return
        }
        
        favorites = Dictionary(uniqueKeysWithValues: movies.map { ($0.id, $0) })
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let favoritesChanged = Notification.Name("com.movieflix.favoritesChanged")
} 
