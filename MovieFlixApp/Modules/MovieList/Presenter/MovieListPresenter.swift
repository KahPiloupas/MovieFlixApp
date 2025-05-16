//
//  MovieListPresenter.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import Foundation

protocol MovieListPresenterProtocol {
    func viewDidLoad()
    func didSelectMovie(_ movie: Movie)
}

class MovieListPresenter: MovieListPresenterProtocol {
    
    weak var view: MovieListViewProtocol?
    var interactor: MovieListInteractorProtocol?
    var router: MovieListRouterProtocol?
    var movies: [Movie]
    
    init(movies: [Movie]) {
        self.movies = movies
    }
    
    func viewDidLoad() {
        view?.displayMovies(movies)
    }
    
    func didSelectMovie(_ movie: Movie) {
        router?.navigateToDetail(from: view, with: movie.id)
    }
}
