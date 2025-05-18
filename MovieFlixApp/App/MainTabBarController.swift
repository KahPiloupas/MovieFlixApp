//
//  MainTabBarController.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 17/05/25.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let gridViewController = MovieGridRouter.createModule()
        let gridNavigationController = UINavigationController(rootViewController: gridViewController)
        gridNavigationController.tabBarItem = UITabBarItem(
            title: "Filmes",
            image: UIImage(systemName: "film"),
            tag: 0
        )
        
        let favoritesViewController = FavoritesRouter.createModule()
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        favoritesNavigationController.tabBarItem = UITabBarItem(
            title: "Favoritos",
            image: UIImage(systemName: "star.fill"),
            tag: 1
        )
        
        viewControllers = [gridNavigationController, favoritesNavigationController]
        
        selectedIndex = 0
    }
}
