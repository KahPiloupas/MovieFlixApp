//
//  SearchRouter.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 15/05/25.
//

import UIKit

protocol SearchRouterProtocol {
    static func createModule() -> UIViewController
    func navigateToMovieList(from view: SearchViewProtocol?, with movies: [Movie])
}

class SearchRouter: SearchRouterProtocol {
    static func createModule() -> UIViewController {
        let view = SearchViewController()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor()
        let router = SearchRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        return view
    }
    
    func navigateToMovieList(from view: SearchViewProtocol?, with movies: [Movie]) {
        let movieListViewController = MovieListRouter.createModule(with: movies)
        if let viewController = view as? UIViewController {
            viewController.navigationController?.pushViewController(movieListViewController, animated: true)
        }
    }
}
