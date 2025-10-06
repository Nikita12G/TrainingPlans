//
//  Plan.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

struct Plan: Codable, Equatable, Identifiable {
    let id: UUID
    var title: String
    var goal: String
    var exercises: [PlannedExercise]

    init(id: UUID = UUID(), title: String = "", goal: String = "", exercises: [PlannedExercise] = []) {
        self.id = id
        self.title = title
        self.goal = goal
        self.exercises = exercises
    }
}
