//
//  SearchRouter.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 15/05/25.
//

import UIKit

protocol SearchRouterProtocol {
    static func createModule() -> UIViewController
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
}
