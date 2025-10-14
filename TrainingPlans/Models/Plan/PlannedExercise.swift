//
//  PlannedExercise.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

struct PlannedExercise: Codable, Equatable, Identifiable {
    let id: UUID
    var exerciseId: String
    var sets: [PlannedSet]

    init(id: UUID = UUID(), exerciseId: String, sets: [PlannedSet] = []) {
        self.id = id
        self.exerciseId = exerciseId
        self.sets = sets
    }
    
    var name: String {
        StaticExercisesLoader.load().first(where: { $0.id == exerciseId })?.name ?? "Unknown exercise"
    }
}
