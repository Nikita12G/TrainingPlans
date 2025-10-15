//
//  PlanWizardExercisesVC.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

final class PlanWizardExercisesVC: UIViewController {
    private let viewModel: PlanWizardExercisesVM
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    init(viewModel: PlanWizardExercisesVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Шаг 2 — Упражнения"
        view.backgroundColor = .systemGreen
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        setupNavBar()
    }

    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Дальше", style: .done, target: self, action: #selector(nextTapped))
    }

    @objc private func nextTapped() {
        viewModel.next()
    }
}

extension PlanWizardExercisesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.availableExercises.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let exercises = viewModel.availableExercises[indexPath.row]
        cell.textLabel?.text = exercises.name
        cell.accessoryType = viewModel.draft.exercises.contains(where: { $0.exerciseId == exercises.id }) ? .checkmark : .none
        return cell
    }
}

extension PlanWizardExercisesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let exercise = viewModel.availableExercises[indexPath.row]
        viewModel.toggleExercise(exercise: exercise)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
