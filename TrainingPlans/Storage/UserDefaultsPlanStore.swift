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
    private var cachedPlans: [Plan] = []
    private var isInitialized = false

    // MARK: - Public API

    func preloadData(completion: @escaping (Bool) -> Void) {
        queue.async {
            guard let data = UserDefaults.standard.data(forKey: self.key) else {
                self.cachedPlans = []
                self.isInitialized = true
                DispatchQueue.main.async { completion(true) }
                return
            }
            do {
                let plans = try JSONDecoder().decode([Plan].self, from: data)
                self.cachedPlans = plans
                self.isInitialized = true
                DispatchQueue.main.async {
                    print("Предварительно загружено \(plans.count) планов из UserDefaults")
                    completion(true)
                }
            } catch {
                print("Ошибка декодирования планов: \(error)")
                self.cachedPlans = []
                self.isInitialized = true
                DispatchQueue.main.async { completion(false) }
            }
        }
    }

    func fetchPlans(completion: @escaping (Result<[Plan], Error>) -> Void) {
        if isInitialized {
            completion(.success(cachedPlans))
            return
        }

        queue.async {
            guard let data = UserDefaults.standard.data(forKey: self.key) else {
                DispatchQueue.main.async { completion(.success([])) }
                return
            }
            do {
                let plans = try JSONDecoder().decode([Plan].self, from: data)
                self.cachedPlans = plans
                self.isInitialized = true
                DispatchQueue.main.async { completion(.success(plans)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
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
                self.cachedPlans = plans
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
                self.cachedPlans = plans
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
