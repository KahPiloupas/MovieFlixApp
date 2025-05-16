//
//  MovieListRouter.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import UIKit

protocol MovieListRouterProtocol {
    func navigateToDetail(from view: MovieListViewProtocol?, with movieId: Int)
}

class MovieListRouter: MovieListRouterProtocol {
    static func createModule(with movies: [Movie]) -> UIViewController {
        let view = MovieListViewController()
        let presenter = MovieListPresenter(movies: movies)
        let interactor = MovieListInteractor()
        let router = MovieListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        return view
    }
}

extension MovieListRouter {
    func navigateToDetail(from view: MovieListViewProtocol?, with movieId: Int) {
        let detailVC = MovieDetailRouter.createModule(with: movieId)
        if let viewController = view as? UIViewController {
            viewController.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
