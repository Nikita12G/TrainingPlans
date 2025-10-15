//
//  MockServicesTests.swift
//  TrainingPlansUnitTest
//
//  Created by Никита Гуляев on 15.10.2025.
//

import XCTest
@testable import TrainingPlans

final class MockServicesTests: XCTestCase {

    func test_MockExercisesService_returnsSuccess() {
        let exercises = ["Push-up", "Squat"]
        let mock = MockExercisesService(behavior: .success(exercises))
        let exp = expectation(description: "fetch")
        mock.fetchExercises { result in
            switch result {
            case .success(let items):
                XCTAssertEqual(items, exercises)
            case .failure(let err):
                XCTFail("Unexpected failure: \(err)")
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 1)
        XCTAssertEqual(mock.fetchCallCount, 1)
    }

    func test_MockPlanStore_saveAndLoad() throws {
        let store = MockPlanStore()
        try store.save(plan: "Plan A")
        XCTAssertEqual(store.saveCallCount, 1)
        let loaded = try store.load()
        XCTAssertEqual(loaded, "Plan A")
    }

    func test_MockPlanStore_saveThrows() {
        enum E: Error { case boom }
        let store = MockPlanStore(shouldThrowOnSave: E.boom)
        XCTAssertThrowsError(try store.save(plan: "X"))
    }
}
