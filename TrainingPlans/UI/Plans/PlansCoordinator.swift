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
    
    // MARK: - Private
    
    private func showWizard(draft: Plan? = nil) {
        let currentDraft = draft ?? Plan()
        wizardDraft = currentDraft
        
        let vm = PlanWizardNameVM(draft: currentDraft, planStore: container.planStore)
        vm.onNext = { [weak self] draftPlan in
            self?.wizardDraft = draftPlan
            self?.showExercisesWizard()
        }
        
        let vc = PlanWizardNameVC(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }

    private func showExercisesWizard() {
        guard let draft = wizardDraft else { return }
        
        let vm = PlanWizardExercisesVM(
            draft: draft,
            exercisesDataProvider: container.exercisesStore)
        vm.onNext = { [weak self] updatedDraft in
            self?.wizardDraft = updatedDraft
            self?.showSummary()
        }
        
        let vc = PlanWizardExercisesVC(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }

    private func showSummary() {
        guard let draft = wizardDraft else { return }
        
        let vm = PlanSummaryVM(
            draft: draft,
            planStore: container.planStore,
            exercisesDataProvider: container.exercisesStore)
        
        vm.onEditName = { [weak self] draftPlan in
            self?.showEditNameAlert(draft: draftPlan)
        }
        
        vm.onEditExercises = { [weak self] draftPlan in
            self?.showEditExercisesAlert(draft: draftPlan)
        }
        
        vm.onSaved = { [weak self] in
            self?.wizardDraft = nil
            self?.navigationController.popToRootViewController(animated: true)
        }
        
        let vc = PlanSummaryVC(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }

    private func showEditNameAlert(draft: Plan) {
        let alert = UIAlertController(
            title: "Изменить название",
            message: "Введите новое название плана",
            preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = draft.title
            textField.placeholder = "Название плана"
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard let newName = alert.textFields?.first?.text, !newName.isEmpty else { return }
            var updatedDraft = draft
            updatedDraft.title = newName
            
            self?.wizardDraft = updatedDraft
            self?.refreshSummaryScreen()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        navigationController.present(alert, animated: true)
    }

    private func showEditExercisesAlert(draft: Plan) {
        let alert = UIAlertController(
            title: "Изменить упражнения",
            message: "Что вы хотите сделать?",
            preferredStyle: .actionSheet)
        
        let editExercisesAction = UIAlertAction(title: "Редактировать упражнения", style: .default) { [weak self] _ in
            guard let currentDraft = self?.wizardDraft else { return }
            self?.wizardDraft = currentDraft
            self?.navigationController.popViewController(animated: true)
        }
        
        let addExerciseAction = UIAlertAction(title: "Добавить упражнение", style: .default) { [weak self] _ in
            guard let currentDraft = self?.wizardDraft else { return }
            self?.wizardDraft = currentDraft
            self?.showExercisesWizard()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(editExercisesAction)
        alert.addAction(addExerciseAction)
        alert.addAction(cancelAction)

        navigationController.present(alert, animated: true)
    }

    private func refreshSummaryScreen() {
        if let summaryVC = navigationController.viewControllers.last as? PlanSummaryVC,
           let draft = wizardDraft {
            summaryVC.updateDraft(plan: draft)
            summaryVC.refresh()
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
