//
//  ExecutionVM.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

final class ExecutionVM {
    let plan: Plan
    private var exercises: [Exercise]

    private(set) var currentIndex: Int = 0
    private(set) var results: [ExerciseResult]
    
    var onUpdate: (() -> Void)?
    var onFinish: ((ExecutionRecord) -> Void)?
    
    var currentExercise: PlannedExercise {
        plan.exercises[currentIndex]
    }
    
    var currentExerciseId: String {
        plan.exercises[currentIndex].exerciseId
    }
    
    init(plan: Plan, exercisesDataProvider: ExercisesDataProvider) {
        self.plan = plan
        self.results = plan.exercises.map { ExerciseResult(exerciseId: $0.exerciseId) }
        self.exercises = exercisesDataProvider.allExercises()
    }
    
    func recordSet(reps: Int, weight: Double) {
        guard currentIndex < results.count else { return }
        results[currentIndex].sets.append(SetResult(reps: reps, weight: weight))
        onUpdate?()
    }
    
    func nextExercise() {
        if currentIndex + 1 < plan.exercises.count {
            currentIndex += 1
            onUpdate?()
        } else {
            finish()
        }
    }
    
    
    func exercise() -> Exercise? {
        return exercises.first { $0.id == currentExerciseId }
    }
    
    private func finish() {
        let record = ExecutionRecord(planId: plan.id, results: results)
        onFinish?(record)
    }
}
