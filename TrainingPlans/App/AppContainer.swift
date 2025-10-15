//
//  AppContainer.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

final class AppContainer {
    let planStore: PlanStoreProtocol
    let exercisesService: ExercisesServiceProtocol
    let exercisesStore: ExercisesDataProvider

    init() {
        let service = ExercisesService()
        self.exercisesService = service
        self.planStore = UserDefaultsPlanStore()
        self.exercisesStore = ExercisesDataProvider(service: service)
    }
}
