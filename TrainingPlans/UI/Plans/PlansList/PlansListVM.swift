//
//  PlansListVM.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

final class PlansListVM {
    private let planStore: PlanStoreProtocol
    private(set) var plans: [Plan] = [] {
        didSet {
            onPlansUpdated?(plans)
        }
    }
    
    var onPlansUpdated: (([Plan]) -> Void)?
    var onCreatePlan: (() -> Void)?
    var onSelectPlan: ((Plan) -> Void)?
    var onError: ((String) -> Void)?
    
    init(planStore: PlanStoreProtocol) {
        self.planStore = planStore
        loadPlans()
    }
    
    func loadPlans() {
        planStore.fetchPlans { [weak self] result in
            switch result {
            case .success(let plans):
                self?.plans = plans
            case .failure:
                self?.plans = []
            }
        }
    }
    
    func createTapped() {
        onCreatePlan?()
    }
    
    func select(plan: Plan) {
        onSelectPlan?(plan)
    }
    
    func deletePlan(at index: Int) {
        guard index >= 0 && index < plans.count else { return }
        
        let planToDelete = plans[index].id
        
        planStore.deletePlan(id: planToDelete) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.plans.remove(at: index)
                case .failure(let error):
                    self?.onError?("Не удалось удалить план: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deletePlan(_ plan: Plan) {
        guard let index = plans.firstIndex(where: { $0.id == plan.id }) else { return }
        deletePlan(at: index)
    }
    
    func canDeletePlan(at index: Int) -> Bool {
        return index >= 0 && index < plans.count
    }
    
    func plan(at index: Int) -> Plan? {
        guard index >= 0 && index < plans.count else { return nil }
        return plans[index]
    }
}
