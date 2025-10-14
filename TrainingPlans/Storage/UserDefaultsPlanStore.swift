//
//  UserDefaultsPlanStore.swift
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

final class UserDefaultsPlanStore: PlanStoreProtocol {
    private let key = "plans_storage_v1"
    private let queue = DispatchQueue(label: "UserDefaultsPlanStore.queue", qos: .background)

    func fetchPlans(completion: @escaping (Result<[Plan], Error>) -> Void) {
        queue.async {
            guard let data = UserDefaults.standard.data(forKey: self.key) else {
                DispatchQueue.main.async { completion(.success([])) }
                return
            }
            do {
                let plans = try JSONDecoder().decode([Plan].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(plans))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func savePlan(_ plan: Plan, completion: @escaping (Result<Void, Error>) -> Void) {
        fetchPlans { result in
            switch result {
            case .success(var plans):
                if let idx = plans.firstIndex(where: { $0.id == plan.id }) {
                    plans[idx] = plan
                } else {
                    plans.append(plan)
                }
                do {
                    let data = try JSONEncoder().encode(plans)
                    UserDefaults.standard.set(data, forKey: self.key)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deletePlan(id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        fetchPlans { result in
            switch result {
            case .success(var plans):
                plans.removeAll { $0.id == id }
                do {
                    let data = try JSONEncoder().encode(plans)
                    UserDefaults.standard.set(data, forKey: self.key)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
