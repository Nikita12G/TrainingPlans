import Foundation
@testable import TrainingPlans

// Simple mock protocol examples for the app's services.
// Adjust protocols/names to match your app; these mocks are designed to be
// compact, Xcode-friendly, and dependency-free.

protocol ExercisesService {
    func fetchExercises(completion: @escaping (Result<[String], Error>) -> Void)
}

final class MockExercisesService: ExercisesService {
    enum Behavior {
        case success([String])
        case failure(Error)
    }
    private let behavior: Behavior
    private(set) var fetchCallCount = 0

    init(behavior: Behavior = .success([])) {
        self.behavior = behavior
    }

    func fetchExercises(completion: @escaping (Result<[String], Error>) -> Void) {
        fetchCallCount += 1
        switch behavior {
        case .success(let items):
            completion(.success(items))
        case .failure(let err):
            completion(.failure(err))
        }
    }
}

protocol PlanStore {
    func save(plan: String) throws
    func load() throws -> String?
}

final class MockPlanStore: PlanStore {
    var storedPlan: String?
    var saveCallCount = 0
    var shouldThrowOnSave: Error?

    init(storedPlan: String? = nil, shouldThrowOnSave: Error? = nil) {
        self.storedPlan = storedPlan
        self.shouldThrowOnSave = shouldThrowOnSave
    }

    func save(plan: String) throws {
        saveCallCount += 1
        if let err = shouldThrowOnSave { throw err }
        storedPlan = plan
    }

    func load() throws -> String? {
        return storedPlan
    }
}
