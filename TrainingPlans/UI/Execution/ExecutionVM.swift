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
    var onUpdate: (() -> Void)?
    var onFinish: ((ExecutionRecord) -> Void)?

    private var results: [ExerciseResult] = []

    init(plan: Plan) {
        self.plan = plan
        self.results = plan.exercises.map { ExerciseResult(exerciseId: $0.exerciseId) }
    }

    func recordSet(reps: Int, weight: Double) {
        guard currentIndex < results.count else { return }
        results[currentIndex].sets.append(SetResult(reps: reps, weight: weight))
    }

    func advance() {
        if currentIndex + 1 < plan.exercises.count {
            currentIndex += 1
            onUpdate?()
        } else {
            finish()
        }
    }

    func finish() {
        let record = ExecutionRecord(planId: plan.id, results: results)
        onFinish?(record)
    }
}
