//
//  PlanWizardNameVM.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

final class PlanWizardNameVM {
    private let planStore: PlanStoreProtocol
    var draft: Plan

    var onNext: ((Plan) -> Void)?

    init(draft: Plan, planStore: PlanStoreProtocol) {
        self.draft = draft
        self.planStore = planStore
    }

    func update(title: String, goal: String) {
        draft.title = title
        draft.goal = goal
    }

    func next() {
        onNext?(draft)
    }
}

