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

    private var childCoordinators: [ExecutionCoordinator] = []
    private var wizardDraft: Plan?

    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }

    func start() {
        let vm = PlansListVM(planStore: container.planStore)
        vm.onCreatePlan = { [weak self] in
            self?.showWizard()
        }
        
        vm.onSelectPlan = { [weak self] plan in
            self?.showPlanDetail(plan: plan)
        }
        
        let vc = PlansListVC(viewModel: vm)
        navigationController.setViewControllers([vc], animated: false)
    }

    private func showWizard(draft: Plan? = nil) {
        let currentDraft = draft ?? Plan()
        wizardDraft = currentDraft
        
        let vm = PlanWizardNameVM(draft: currentDraft, planStore: container.planStore)
        vm.onNext = { [weak self] draftPlan in
            self?.wizardDraft = draftPlan
            self?.showExercisesWizard()
        }
        
        let vc = PlanWizardNameVC(viewModel: vm)
        
        if let existingVC = navigationController.viewControllers.first(where: { $0 is PlanWizardNameVC }) {
            navigationController.popToViewController(existingVC, animated: true)
        } else {
            navigationController.pushViewController(vc, animated: true)
        }
    }

    private func showExercisesWizard() {
        guard let draft = wizardDraft else { return }
        
        let vm = PlanWizardExercisesVM(draft: draft)
        vm.onNext = { [weak self] updatedDraft in
            self?.wizardDraft = updatedDraft
            self?.showSummary()
        }
        
        let vc = PlanWizardExercisesVC(viewModel: vm)
        
        if let existingVC = navigationController.viewControllers.first(where: { $0 is PlanWizardExercisesVC }) {
            navigationController.popToViewController(existingVC, animated: true)
        } else {
            navigationController.pushViewController(vc, animated: true)
        }
    }

    private func showSummary() {
        guard let draft = wizardDraft else { return }
        
        let vm = PlanSummaryVM(draft: draft, planStore: container.planStore)
        vm.onEditName = { [weak self] draftPlan in
            self?.wizardDraft = draftPlan
            self?.showWizard(draft: draftPlan)
        }
        
        vm.onEditExercises = { [weak self] draftPlan in
            self?.wizardDraft = draftPlan
            self?.showExercisesWizard()
        }
        
        vm.onSaved = { [weak self] in
            self?.wizardDraft = nil
            self?.navigationController.popToRootViewController(animated: true)
        }
        
        let vc = PlanSummaryVC(viewModel: vm)
        
        if let existingVC = navigationController.viewControllers.first(where: { $0 is PlanSummaryVC }) {
            navigationController.popToViewController(existingVC, animated: true)
        } else {
            navigationController.pushViewController(vc, animated: true)
        }
    }

    private func showPlanDetail(plan: Plan) {
        let vm = PlanDetailVM(plan: plan)
        let vc = PlanDetailVC(viewModel: vm)

        vm.onStart = { [weak self] in
            guard let self = self else { return }

            let execCoord = ExecutionCoordinator(
                navigationController: self.navigationController,
                container: self.container,
                plan: plan
            )

            self.childCoordinators.append(execCoord)

            execCoord.didFinish = { [weak self] in
                self?.childCoordinators.removeAll { $0 === execCoord }
                self?.navigationController.popToRootViewController(animated: true)
            }

            execCoord.start()
        }

        navigationController.pushViewController(vc, animated: true)
    }
}
