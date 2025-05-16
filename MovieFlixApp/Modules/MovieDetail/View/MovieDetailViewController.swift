//
//  MovieDetailViewController.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    func displayMovieDetail(_ detail: MovieDetail)
    func displayError(_ message: String)
}

class MovieDetailViewController: UIViewController, MovieDetailViewProtocol {
    
    var presenter: MovieDetailPresenterProtocol!
    private var currentMovie: MovieDetail?
    
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Detalhes do Filme"
        
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        overviewLabel.numberOfLines = 0
        
        favoriteButton.setTitle("Favoritar", for: .normal)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, overviewLabel, favoriteButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func toggleFavorite() {
        guard let movie = currentMovie else { return }
        let isFavorite = FavoritesManager.shared.isFavorite(id: movie.id)
        if isFavorite {
            FavoritesManager.shared.removeFavorite(id: movie.id)
        } else {
            FavoritesManager.shared.saveFavorite(movie)
        }
        updateFavoriteButton(isFavorite: !isFavorite)
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        favoriteButton.setTitle(isFavorite ? "Remover Favorito" : "Favoritar", for: .normal)
    }
    
    func displayMovieDetail(_ detail: MovieDetail) {
        currentMovie = detail
        titleLabel.text = "\(detail.originalTitle) ⭐️ \(detail.voteAverage)"
        overviewLabel.text = detail.overview
        let isFavorite = FavoritesManager.shared.isFavorite(id: detail.id)
        updateFavoriteButton(isFavorite: isFavorite)
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
