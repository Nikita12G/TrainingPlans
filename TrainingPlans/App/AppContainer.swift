//
//  AppContainer.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

final class AppContainer {
    lazy var planStore: PlanStoreProtocol = UserDefaultsPlanStore()
}
