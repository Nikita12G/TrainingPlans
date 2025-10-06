//
//  PlanWizardExercisesVM.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

final class PlanWizardExercisesVM {
    var draft: Plan
    var onNext: ((Plan) -> Void)?

    // For simplicity: static list of available exercise ids
    let availableExercises = ["squat", "bench", "deadlift", "row"]

    init(draft: Plan) {
        self.draft = draft
    }

    func toggleExercise(id: String) {
        if let idx = draft.exercises.firstIndex(where: { $0.exerciseId == id }) {
            draft.exercises.remove(at: idx)
        } else {
            let pe = PlannedExercise(exerciseId: id, sets: [PlannedSet(targetReps: 5, targetWeight: 0)])
            draft.exercises.append(pe)
        }
    }

    func next() {
        onNext?(draft)
    }
}
