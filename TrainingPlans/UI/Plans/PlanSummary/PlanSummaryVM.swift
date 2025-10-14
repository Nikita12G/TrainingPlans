//
//  PlanSummaryVM.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

final class PlanSummaryVM {
    private(set) var draft: Plan 
    private let planStore: PlanStoreProtocol
    
    var onEditName: ((Plan) -> Void)?
    var onEditExercises: ((Plan) -> Void)?
    var onSaved: (() -> Void)?
    
    var planName: String {
        draft.title
    }
    
    var exercisesCount: Int {
        draft.exercises.count
    }
    
    init(draft: Plan, planStore: PlanStoreProtocol) {
        self.draft = draft
        self.planStore = planStore
    }
    
    func editName() {
        onEditName?(draft)
    }
    
    func editExercises() {
        onEditExercises?(draft)
    }
    
    func save() {
        planStore.savePlan(draft) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.onSaved?()
                case .failure(let error):
                    print("Error saving plan: \(error)")
                }
            }
        }
    }
    
    func updateDraft(_ newDraft: Plan) {
        self.draft = newDraft
    }
}
