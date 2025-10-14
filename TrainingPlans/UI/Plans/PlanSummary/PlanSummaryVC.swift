//
//  PlanSummaryVC.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

final class PlanSummaryVC: UIViewController {
    private let viewModel: PlanSummaryVM
    
    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var editNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Name", for: .normal)
        button.addTarget(self, action: #selector(editNameTapped), for: .touchUpInside)
        return button
    }()
    private lazy var editExercisesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Exercises", for: .normal)
        button.addTarget(self, action: #selector(editExercisesTapped), for: .touchUpInside)
        return button
    }()
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Plan", for: .normal)
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [editNameButton, editExercisesButton, saveButton])
        stack.axis = .vertical
        stack.spacing = 12
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
        title = "Summary"
        view.backgroundColor = .systemGray
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

    private func refresh() {
        let text = "Title: \(viewModel.draft.title)\nGoal: \(viewModel.draft.goal)\nExercises: \(viewModel.draft.exercises.map { $0.name }.joined(separator: ", "))"
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
