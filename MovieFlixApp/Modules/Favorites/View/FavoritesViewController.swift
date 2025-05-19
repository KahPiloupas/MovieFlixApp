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
    private let emptyStateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Favorite Movies"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavoriteMovieCell.self, forCellReuseIdentifier: FavoriteMovieCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        emptyStateLabel.text = "There are no favorite movies yet."
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.textColor = .darkGray
        emptyStateLabel.font = .systemFont(ofSize: 18)
        emptyStateLabel.isHidden = true
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteMovieCell.identifier, for: indexPath) as? FavoriteMovieCell else {
            return UITableViewCell()
        }
        
        let movieDetail = movies[indexPath.row]
        cell.configure(with: movieDetail)
        
        cell.favoriteAction = { [weak self] (movieId: Int) in
            self?.presenter.didTapRemove(id: movieDetail.id)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movieId = movies[indexPath.row].id
        presenter.didSelectMovie(id: movieId)
    }
}

extension FavoritesViewController: FavoritesViewProtocol {
    func displayFavorites(_ movies: [MovieDetail]) {
        self.movies = movies
        tableView.reloadData()
        
        emptyStateLabel.isHidden = !movies.isEmpty
        tableView.isHidden = movies.isEmpty
    }
}
