//
//  PlanWizardNameVC.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

final class PlanWizardNameVC: UIViewController {
    private let viewModel: PlanWizardNameVM
    private lazy var titleField = UITextField()
    private lazy var goalField = UITextField()

    init(viewModel: PlanWizardNameVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Step 1 — Name"
        view.backgroundColor = .systemYellow
        setupFields()
        setupNext()
    }

    private func setupFields() {
        titleField.placeholder = "Plan title"
        goalField.placeholder = "Goal"
        titleField.borderStyle = .roundedRect
        goalField.borderStyle = .roundedRect
        let stack = UIStackView(arrangedSubviews: [titleField, goalField])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    private func setupNext() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTapped))
    }

    @objc private func nextTapped() {
        viewModel.update(title: titleField.text ?? "", goal: goalField.text ?? "")
        viewModel.next()
    }
}
