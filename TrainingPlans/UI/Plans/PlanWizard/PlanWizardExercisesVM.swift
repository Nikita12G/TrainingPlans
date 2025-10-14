//
//  PlanWizardExercisesVM.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

final class PlanWizardExercisesVM {
    let availableExercises: [Exercise]
    
    var draft: Plan
    var onNext: ((Plan) -> Void)?

    init(draft: Plan, exercisesDataProvider: ExercisesDataProvider) {
        self.draft = draft
        self.availableExercises = exercisesDataProvider.allExercises()
    }

    func toggleExercise(exercise: Exercise) {
        if let idx = draft.exercises.firstIndex(where: { $0.exerciseId == exercise.id }) {
            draft.exercises.remove(at: idx)
        } else {
            let plannedExercise = PlannedExercise(
                exerciseId: exercise.id,
                sets: [PlannedSet(targetReps: 5, targetWeight: 0)]
            )
            draft.exercises.append(plannedExercise)
        }
    }
    
    func next() {
        onNext?(draft)
    }
}
