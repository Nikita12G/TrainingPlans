//
//  ExecutionSummaryVC.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

final class ExecutionSummaryVC: UIViewController {
    private let viewModel: ExecutionSummaryVM
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        return button
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(viewModel: ExecutionSummaryVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Summary"
        view.backgroundColor = .systemBackground
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        setUpUI()
    }
    
    private func setUpUI() {
        let exercises = StaticExercisesLoader.load()
        
        let summaryLines = viewModel.record.results.map { exerciseResult in
            let exerciseName = exercises.first { $0.id == exerciseResult.exerciseId }?.name ?? exerciseResult.exerciseId
            
            let setsText = exerciseResult.sets.enumerated().map { index, set in
                "  Set \(index + 1): \(set.reps)x\(set.weight)kg"
            }.joined(separator: "\n")
            
            return "\(exerciseName):\n\(setsText)"
        }
        
        let fullText = ["Workout Summary", ""] + summaryLines + [""]
        resultLabel.text = fullText.joined(separator: "\n")
        
        stackView.addArrangedSubview(resultLabel)
        stackView.addArrangedSubview(doneButton)
    }
    
    @objc private func doneTapped() {
        viewModel.done()
    }
}
