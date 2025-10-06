//
//  PlansCoordinator.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

final class PlansCoordinator {
    private let navigationController: UINavigationController
    private let container: AppContainer

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let vm = PlansListVM(planStore: container.planStore)
        let vc = PlansListVC(viewModel: vm)
        vm.onCreatePlan = { [weak self] in self?.showWizard() }
        vm.onSelectPlan = { [weak self] plan in self?.showPlanDetail(plan: plan) }
        navigationController.setViewControllers([vc], animated: false)
    }

    private func showWizard(draft: Plan? = nil) {
        let vm = PlanWizardNameVM(draft: draft ?? Plan(), planStore: container.planStore)
        let vc = PlanWizardNameVC(viewModel: vm)
        vm.onNext = { [weak self] draftPlan in
            self?.showExercisesWizard(draft: draftPlan)
        }
        navigationController.pushViewController(vc, animated: true)
    }

    private func showExercisesWizard(draft: Plan) {
        let vm = PlanWizardExercisesVM(draft: draft)
        let vc = PlanWizardExercisesVC(viewModel: vm)
        vm.onNext = { [weak self] updatedDraft in
            self?.showSummary(draft: updatedDraft)
        }
        navigationController.pushViewController(vc, animated: true)
    }

    private func showSummary(draft: Plan) {
        let vm = PlanSummaryVM(draft: draft, planStore: container.planStore)
        let vc = PlanSummaryVC(viewModel: vm)
        vm.onEditName = { [weak self] draftPlan in
            self?.showWizard(draft: draftPlan)
        }
        vm.onEditExercises = { [weak self] draftPlan in
            self?.showExercisesWizard(draft: draftPlan)
        }
        vm.onSaved = { [weak self] in
            self?.navigationController.popToRootViewController(animated: true)
        }
        navigationController.pushViewController(vc, animated: true)
    }

    private func showPlanDetail(plan: Plan) {
        let coord = ExecutionCoordinator(navigationController: navigationController, container: container, plan: plan)
        coord.startFromDetail()
    }
}
