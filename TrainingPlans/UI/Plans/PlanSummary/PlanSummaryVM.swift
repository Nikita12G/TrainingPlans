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
    private var exercises: [Exercise]

    var onEditName: ((Plan) -> Void)?
    var onEditExercises: ((Plan) -> Void)?
    var onSaved: (() -> Void)?
    
    var planName: String {
        draft.title
    }
    
    var exercisesCount: Int {
        draft.exercises.count
    }
    
    init(draft: Plan, planStore: PlanStoreProtocol, exercisesDataProvider: ExercisesDataProvider) {
        self.draft = draft
        self.planStore = planStore
        self.exercises = exercisesDataProvider.allExercises()
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
                    print("Ошибка сохранения плана: \(error)")
                }
            }
        }
    }
    
    func updateDraft(_ newDraft: Plan) {
        self.draft = newDraft
    }
    
    func exercise(with id: String) -> Exercise? {
        return exercises.first { $0.id == id }
    }
}
