//
//  PlanSummaryVM.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

final class PlanSummaryVM {
    private let planStore: PlanStoreProtocol
    var draft: Plan

    var onSaved: (() -> Void)?
    var onEditName: ((Plan) -> Void)?
    var onEditExercises: ((Plan) -> Void)?

    init(draft: Plan, planStore: PlanStoreProtocol) {
        self.draft = draft
        self.planStore = planStore
    }

    func save() {
        planStore.savePlan(draft) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.onSaved?()
                case .failure(let err):
                    print("Save error: \(err)")
                }
            }
        }
    }

    func editName() {
        onEditName?(draft)
    }
    
    func editExercises() {
        onEditExercises?(draft)
    }
}
