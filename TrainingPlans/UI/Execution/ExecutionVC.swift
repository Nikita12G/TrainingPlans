//
//  ExecutionVC.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

final class ExecutionVC: UIViewController {
    private let viewModel: ExecutionVM
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    private lazy var resultsTextView = UITextView()
    private lazy var repsField: UITextField = {
        let field = UITextField()
        field.placeholder = "Повторения"
        field.keyboardType = .numberPad
        return field
    }()
    private lazy var weightField: UITextField = {
        let field = UITextField()
        field.placeholder = "Вес (кг)"
        field.keyboardType = .decimalPad
        return field
    }()
    private lazy var addSetButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Добавить подход", for: .normal)
        button.addTarget(self, action: #selector(addSetTapped), for: .touchUpInside)
        return button
    }()
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Следующее упражнение →", for: .normal)
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            resultsTextView,
            repsField,
            weightField,
            addSetButton,
            nextButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(viewModel: ExecutionVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Упражнения"
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        viewModel.onUpdate = { [weak self] in
            self?.updateUI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        titleLabel.text = "Текущее упрежнение: \(viewModel.exercise()?.name ?? "Без названия")"
        
        _ = viewModel.currentExercise
        var summary = ""
        if let result = viewModel.resultsForCurrentExercise {
            for (i, set) in result.sets.enumerated() {
                summary += "Подход \(i + 1): \(set.reps)x\(set.weight)кг\n"
            }
        }
        resultsTextView.text = summary.isEmpty ? "Ни одного подхода не выполнено." : summary
    }
    
    @objc private func addSetTapped() {
        let reps = Int(repsField.text ?? "") ?? 0
        let weight = Double(weightField.text ?? "") ?? 0
        viewModel.recordSet(reps: reps, weight: weight)
        repsField.text = ""
        weightField.text = ""
    }
    
    @objc private func nextTapped() {
        viewModel.nextExercise()
    }
}

private extension ExecutionVM {
    var resultsForCurrentExercise: ExerciseResult? {
        guard currentIndex < results.count else { return nil }
        return results[currentIndex]
    }
}
