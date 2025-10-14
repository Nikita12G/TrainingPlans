//
//  ExecutionVM.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

final class ExecutionVM {
    let plan: Plan
    
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
    
    var currentExerciseName: String {
        StaticExercisesLoader.load().first(where: { $0.id == currentExerciseId })?.name ?? currentExerciseId
    }
    
    init(plan: Plan) {
        self.plan = plan
        self.results = plan.exercises.map { ExerciseResult(exerciseId: $0.exerciseId) }
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
    
    private func finish() {
        let record = ExecutionRecord(planId: plan.id, results: results)
        onFinish?(record)
    }
}
