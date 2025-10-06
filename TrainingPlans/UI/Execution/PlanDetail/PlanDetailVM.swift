//
//  PlanDetailVM.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import Foundation

final class PlanDetailVM {
    let plan: Plan
    var onStart: (() -> Void)?

    init(plan: Plan) { self.plan = plan }

    func startTapped() { onStart?() }
}
