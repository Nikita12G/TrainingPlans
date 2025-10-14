//
//  PlanSummaryVC.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

final class PlanSummaryVC: UIViewController {
    let viewModel: PlanSummaryVM
    
    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var editNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить название", for: .normal)
        button.addTarget(self, action: #selector(editNameTapped), for: .touchUpInside)
        return button
    }()
    private lazy var editExercisesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить упражнения", for: .normal)
        button.addTarget(self, action: #selector(editExercisesTapped), for: .touchUpInside)
        return button
    }()
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить план", for: .normal)
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [editNameButton, editExercisesButton, saveButton])
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init(viewModel: PlanSummaryVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Результат"
        view.backgroundColor = .lightGray
        view.addSubview(summaryLabel)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            summaryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    func refresh() {
        let text = "Тренировка: \(viewModel.draft.title)\nГруппа мышц: \(viewModel.draft.goal)\nУпражнения: \(viewModel.draft.exercises.map { "\n    ✅ \(viewModel.exercise(with: $0.exerciseId)?.name ?? "без названия")" }.joined(separator: ", "))"
        summaryLabel.text = text
    }

    @objc private func editNameTapped() {
        viewModel.editName()
    }
    
    @objc private func editExercisesTapped() {
        viewModel.editExercises()
    }
    
    @objc private func saveTapped() {
        viewModel.save()
    }
}
