//
//  PlansListVM.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

final class PlansListVM {
    private let planStore: PlanStoreProtocol
    private(set) var plans: [Plan] = [] { didSet {
        onPlansUpdated?(plans)
    } }

    var onPlansUpdated: (([Plan]) -> Void)?
    var onCreatePlan: (() -> Void)?
    var onSelectPlan: ((Plan) -> Void)?

    init(planStore: PlanStoreProtocol) {
        self.planStore = planStore
        loadPlans()
    }

    func loadPlans() {
        planStore.fetchPlans { [weak self] result in
            switch result {
            case .success(let plans): self?.plans = plans
            case .failure: self?.plans = []
            }
        }
    }

    func createTapped() {
        onCreatePlan?()
    }

    func select(plan: Plan) {
        onSelectPlan?(plan)
    }
}
