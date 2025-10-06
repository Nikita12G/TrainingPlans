//
//  ExerciseResult.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

struct ExerciseResult: Codable, Equatable, Identifiable {
    let id: UUID
    let exerciseId: String
    var sets: [SetResult]

    init(id: UUID = UUID(), exerciseId: String, sets: [SetResult] = []) {
        self.id = id
        self.exerciseId = exerciseId
        self.sets = sets
    }
}
