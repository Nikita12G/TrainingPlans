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
    
    private let executionVM: ExecutionVM
    private let executionVC: ExecutionVC
    
    
    var didFinish: (() -> Void)?
    
    private var record: ExecutionRecord?
    
    init(navigationController: UINavigationController, container: AppContainer, plan: Plan) {
        self.navigationController = navigationController
        self.container = container
        self.plan = plan
        self.executionVM = ExecutionVM(
            plan: plan,
            exercisesDataProvider: container.exercisesStore)
        self.executionVC = ExecutionVC(viewModel: executionVM)
    }
    
    func start() {
        executionVM.onUpdate = { [weak self] in
            self?.executionVC.updateUI()
        }
        
        executionVM.onFinish = { [weak self] record in
            self?.showSummary(record: record)
        }
        
        navigationController.pushViewController(executionVC, animated: true)
    }
    
    private func showSummary(record: ExecutionRecord) {
        self.record = record
        let executionSummaryVM = ExecutionSummaryVM(
            record: record,
            exercises: container.exercisesStore)
        let executionSummaryVC = ExecutionSummaryVC(viewModel: executionSummaryVM)
        
        executionSummaryVM.onDone = { [weak self] in
            print("Сохранена тренировка: \(record)")
            self?.didFinish?()
        }
        
        navigationController.pushViewController(executionSummaryVC, animated: true)
    }
}
