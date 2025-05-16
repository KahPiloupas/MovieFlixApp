//
//  FavoritesManager.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

class FavoritesManager {
    private let key = "favorite_movies"
    
    static let shared = FavoritesManager()
    
    private init() {}
    
    func saveFavorite(_ movie: MovieDetail) {
        var current = fetchFavorites()
        guard !current.contains(where: { $0.id == movie.id }) else { return }
        current.append(movie)
        persist(current)
    }
    
    func removeFavorite(id: Int) {
        var current = fetchFavorites()
        current.removeAll { $0.id == id }
        persist(current)
    }
    
    func isFavorite(id: Int) -> Bool {
        return fetchFavorites().contains(where: { $0.id == id })
    }
    
    func fetchFavorites() -> [MovieDetail] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let favorites = try? JSONDecoder().decode([MovieDetail].self, from: data) else {
            return []
        }
        return favorites
    }
    
    private func persist(_ favorites: [MovieDetail]) {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
