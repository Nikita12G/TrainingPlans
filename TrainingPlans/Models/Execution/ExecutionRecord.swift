//
//  ExecutionRecord.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

struct ExecutionRecord: Codable, Equatable, Identifiable {
    let id: UUID
    let planId: UUID
    let date: Date
    var results: [ExerciseResult]

    init(id: UUID = UUID(), planId: UUID, date: Date = Date(), results: [ExerciseResult] = []) {
        self.id = id
        self.planId = planId
        self.date = date
        self.results = results
    }
}
