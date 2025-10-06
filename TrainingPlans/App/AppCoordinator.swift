//
//  AppCoordinator.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

final class AppCoordinator {
    private let navigationController: UINavigationController
    private let container: AppContainer
    private var plansCoordinator: PlansCoordinator?

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let coordinator = PlansCoordinator(navigationController: navigationController, container: container)
        self.plansCoordinator = coordinator
        coordinator.start()
    }
}
