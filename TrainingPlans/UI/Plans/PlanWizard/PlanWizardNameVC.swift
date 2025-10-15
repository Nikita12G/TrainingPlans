//
//  PlanWizardNameVC.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

final class PlanWizardNameVC: UIViewController {
    private let viewModel: PlanWizardNameVM
    
    private lazy var titleField: UITextField = {
        let titleField = UITextField()
        titleField.placeholder = "Название тренировки"
        titleField.borderStyle = .roundedRect
        return titleField
    }()
    private lazy var goalField: UITextField = {
        let goalField = UITextField()
        goalField.borderStyle = .roundedRect
        goalField.placeholder = "Целевая группа мышц"
        return goalField
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleField, goalField])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(viewModel: PlanWizardNameVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Шаг 1 — Название"
        view.backgroundColor = .systemYellow
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        setupNavBar()
    }

    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Дальше", style: .done, target: self, action: #selector(nextTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
    }

    @objc private func nextTapped() {
        viewModel.update(title: titleField.text ?? "", goal: goalField.text ?? "")
        viewModel.next()
    }
}
