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

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
             self.performInitialDataLoad()
         }
    }

    // MARK: - Private

    private func showLoading() {
        let loadingVC = LoadingVC()
        navigationController.setViewControllers([loadingVC], animated: false)
    }

    private func performInitialDataLoad() {
        let group = DispatchGroup()

        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            self.container.exercisesStore.initialiseData()
            group.leave()
        }

        group.enter()
        container.planStore.fetchPlans { _ in
            group.leave()
        }

        group.notify(queue: .main) {
            self.showMainFlow()
        }
    }

    private func showMainFlow() {
        let plansCoordinator = PlansCoordinator(
            navigationController: navigationController,
            container: container)
        plansCoordinator.start()
    }
}
