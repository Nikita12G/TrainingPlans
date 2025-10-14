//
//  SceneDelegate.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let container = AppContainer()
        let navController = UINavigationController()
        window.rootViewController = navController
        
        self.window = window
        self.appCoordinator = AppCoordinator(navigationController: navController, container: container)
        appCoordinator?.start()
        
        window.makeKeyAndVisible()
    }
}
