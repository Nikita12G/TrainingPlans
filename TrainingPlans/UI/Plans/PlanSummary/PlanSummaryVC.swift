//
//  PlanSummaryVC.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

final class PlanSummaryVC: UIViewController {
    private let viewModel: PlanSummaryVM
    private lazy var summaryLabel = UILabel()

    init(viewModel: PlanSummaryVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Summary"
        view.backgroundColor = .systemBlue
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    private func setupUI() {
        summaryLabel.numberOfLines = 0
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryLabel)
        NSLayoutConstraint.activate([
            summaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            summaryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])

        let editName = UIButton(type: .system)
        editName.setTitle("Edit Name", for: .normal)
        editName.addTarget(self, action: #selector(editNameTapped), for: .touchUpInside)

        let editExercises = UIButton(type: .system)
        editExercises.setTitle("Edit Exercises", for: .normal)
        editExercises.addTarget(self, action: #selector(editExercisesTapped), for: .touchUpInside)

        let save = UIButton(type: .system)
        save.setTitle("Save Plan", for: .normal)
        save.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [editName, editExercises, save])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 20),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        refresh()
    }

    private func refresh() {
        let text = "Title: \(viewModel.draft.title)\nGoal: \(viewModel.draft.goal)\nExercises: \(viewModel.draft.exercises.map { $0.exerciseId }.joined(separator: ", "))"
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
