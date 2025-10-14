//
//  StaticExercisesLoader.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 07.10.2025.
//

import Foundation

enum StaticExercisesLoader {
    static func load() -> [Exercise] {
        guard let url = Bundle.main.url(forResource: "StaticExercises", withExtension: "json") else {
            print("❌ StaticExercises.json not found")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Exercise].self, from: data)
        } catch {
            print("❌ Failed to parse StaticExercises.json: \(error)")
            return []
        }
    }
}
