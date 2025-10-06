//
//  PlanStoreProtocol.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

protocol PlanStoreProtocol {
    func fetchPlans(completion: @escaping (Result<[Plan], Error>) -> Void)
    func savePlan(_ plan: Plan, completion: @escaping (Result<Void, Error>) -> Void)
    func deletePlan(id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
}
