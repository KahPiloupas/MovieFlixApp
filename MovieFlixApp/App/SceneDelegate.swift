//
//  SceneDelegate.swift
//  MovieFlixApp
//
//  Created by Karina Piloupas on 15/05/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let movieGridViewController = MovieGridRouter.createModule()
        let navigationController = UINavigationController(rootViewController: movieGridViewController)
        
        let favoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "star.fill"),
            style: .plain,
            target: self,
            action: #selector(showFavorites)
        )
        movieGridViewController.navigationItem.leftBarButtonItem = favoritesButton
        
        window.rootViewController = navigationController
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
    @objc func showFavorites() {
        guard let navigationController = window?.rootViewController as? UINavigationController else { return }
        
        let favoritesVC = FavoritesRouter.createModule()
        navigationController.pushViewController(favoritesVC, animated: true)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

