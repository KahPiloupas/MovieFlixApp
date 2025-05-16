//
//  FavoritesViewController.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import UIKit

protocol FavoritesViewProtocol: AnyObject {
    func displayFavorites(_ movies: [MovieDetail])
}

class FavoritesViewController: UIViewController {
    
    var presenter: FavoritesPresenterProtocol!
    private var movies: [MovieDetail] = []
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Favoritos"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { movies.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        cell.textLabel?.text = "\(movie.title) ⭐️ \(movie.voteAverage)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectMovie(id: movies[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.didTapRemove(id: movies[indexPath.row].id)
        }
    }
}

extension FavoritesViewController: FavoritesViewProtocol {
    func displayFavorites(_ movies: [MovieDetail]) {
        self.movies = movies
        tableView.reloadData()
    }
}
