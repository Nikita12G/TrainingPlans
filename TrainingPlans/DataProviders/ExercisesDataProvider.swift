//
//  ExercisesDataProvider.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 14.10.2025.
//

import Foundation

final class ExercisesDataProvider {
    private let storageKey = "cached_exercises"
    private let userDefaults = UserDefaults.standard
    private let service: ExercisesServiceProtocol
    private var exercises: [Exercise] = []

    init(service: ExercisesServiceProtocol) {
        self.service = service
    }

    func initialiseData() {
        print("Инициализация ExercisesDataProvider...")
        if let cached = loadFromCache(), !cached.isEmpty {
            self.exercises = cached
            print("Загружено \(cached.count) упражнений из кэша.")
        } else {
            let loaded = service.load()
            self.exercises = loaded
            saveToCache(loaded)
            print("Сохранено \(loaded.count) упражнений в локальное хранилище.")
        }
    }

    func allExercises() -> [Exercise] {
        return exercises
    }

    private func saveToCache(_ exercises: [Exercise]) {
        do {
            let data = try JSONEncoder().encode(exercises)
            userDefaults.set(data, forKey: storageKey)
        } catch {
            print("Ошибка при сохранении упражнений в кэш: \(error)")
        }
    }

    private func loadFromCache() -> [Exercise]? {
        guard let data = userDefaults.data(forKey: storageKey) else { return nil }
        do {
            return try JSONDecoder().decode([Exercise].self, from: data)
        } catch {
            print("Ошибка при чтении упражнений из кэша: \(error)")
            return nil
        }
    }
}
