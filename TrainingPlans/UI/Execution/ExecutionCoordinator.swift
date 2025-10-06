//
//  ExecutionCoordinator.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

final class ExecutionCoordinator {
    private let navigationController: UINavigationController
    private let container: AppContainer
    private let plan: Plan

    init(navigationController: UINavigationController, container: AppContainer, plan: Plan) {
        self.navigationController = navigationController
        self.container = container
        self.plan = plan
    }

    func startFromDetail() {
        let vm = PlanDetailVM(plan: plan)
        let vc = PlanDetailVC(viewModel: vm)
        vm.onStart = { [weak self] in
            self?.startExecution()
        }
        
        navigationController.pushViewController(vc, animated: true)
    }

    private func startExecution() {
        let vm = ExecutionVM(plan: plan)
        let vc = ExecutionVC(viewModel: vm)
        vm.onFinish = { [weak self] record in
            // For now just pop to root and log
            print("Execution finished: \(record)")
            self?.navigationController.popToRootViewController(animated: true)
        }
        
        navigationController.pushViewController(vc, animated: true)
    }
}
