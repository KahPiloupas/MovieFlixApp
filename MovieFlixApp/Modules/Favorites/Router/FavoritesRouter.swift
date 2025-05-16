//
//  FavoritesRouter.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import UIKit

protocol FavoritesRouterProtocol {
    func navigateToDetail(from view: FavoritesViewProtocol?, movieId: Int)
}

class FavoritesRouter: FavoritesRouterProtocol {
    static func createModule() -> UIViewController {
        let view = FavoritesViewController()
        let presenter = FavoritesPresenter()
        let interactor = FavoritesInteractor()
        let router = FavoritesRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter

        return view
    }

    func navigateToDetail(from view: FavoritesViewProtocol?, movieId: Int) {
        let detailViewController = MovieDetailRouter.createModule(with: movieId)
        if let vc = view as? UIViewController {
            vc.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
