//
//  MovieDetailRouter.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 16/05/25.
//

import UIKit

protocol MovieDetailRouterProtocol {}

class MovieDetailRouter: MovieDetailRouterProtocol {
    static func createModule(with movieId: Int) -> UIViewController {
        let view = MovieDetailViewController()
        let presenter = MovieDetailPresenter(movieId: movieId)
        let interactor = MovieDetailInteractor(movieId: movieId)
        let router = MovieDetailRouter()

        view.presenter = presenter
        presenter.view = view 
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter

        return view
    }
}
