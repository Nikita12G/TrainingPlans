//
//  ExecutionSummaryVM.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 07.10.2025.
//

import Foundation

final class ExecutionSummaryVM {
    let record: ExecutionRecord
    let exercises: [Exercise]
    var onDone: (() -> Void)?
    
    init(record: ExecutionRecord, exercises: ExercisesDataProvider) {
        self.record = record
        self.exercises = exercises.allExercises()
    }
    
    func done() {
        onDone?()
    }
}
