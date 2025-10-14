//
//  ExecutionSummaryVM.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 07.10.2025.
//

import Foundation

final class ExecutionSummaryVM {
    let record: ExecutionRecord
    var onDone: (() -> Void)?
    
    init(record: ExecutionRecord) {
        self.record = record
    }
    
    func done() {
        onDone?()
    }
}
