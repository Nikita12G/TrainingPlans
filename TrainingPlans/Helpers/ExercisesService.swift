//
//  ExercisesService.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

protocol ExercisesServiceProtocol {
    func load() -> [Exercise]
}

final class ExercisesService: ExercisesServiceProtocol {
    func load() -> [Exercise] {
        guard let url = Bundle.main.url(forResource: "StaticExercises", withExtension: "json") else {
            print("Не найден StaticExercises.json")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            let exercises = try JSONDecoder().decode([Exercise].self, from: data)
            print("Загружено \(exercises.count) упражнений из StaticExercises.json")
            return exercises
        } catch {
            print("Ошибка при загрузке упражнений: \(error)")
            return []
        }
    }
}
