//
//  MovieGridRouter.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 17/05/25.
//

import UIKit

protocol MovieGridRouterProtocol {
    func navigateToMovieDetail(from view: MovieGridViewProtocol?, with movieId: Int)
}

class MovieGridRouter: MovieGridRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = MovieGridViewController()
        let presenter = MovieGridPresenter()
        let interactor = MovieGridInteractor()
        let router = MovieGridRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        
        return view
    }
    
    func navigateToMovieDetail(from view: MovieGridViewProtocol?, with movieId: Int) {
        let detailVC = MovieDetailRouter.createModule(with: movieId)
        
        if let viewController = view as? UIViewController {
            viewController.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
