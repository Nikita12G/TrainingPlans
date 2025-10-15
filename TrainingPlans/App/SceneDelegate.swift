//
//  SceneDelegate.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let navController = UINavigationController()

        let container = AppContainer()
        let coordinator = AppCoordinator(
            navigationController: navController,
            container: container)

        window.rootViewController = navController
        self.window = window

        window.makeKeyAndVisible()
        coordinator.start()
    }
}
