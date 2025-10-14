//
//  PlansListVC.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

final class PlansListVC: UIViewController {
    private let viewModel: PlansListVM
    
    private lazy var tableView = UITableView()
    
    init(viewModel: PlansListVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Plans"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        setupTable()
        setupNavBar()
        viewModel.onPlansUpdated = { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.onError = { error in
            print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadPlans()
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "+",
            style: .done,
            target: self,
            action: #selector(newTapped))
    }
    
    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        tableView.tableFooterView = UIView()
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc
    private func newTapped() {
        viewModel.createTapped()
    }
}

extension PlansListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.plans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let plan = viewModel.plans[indexPath.row]
        cell.textLabel?.text = plan.title.isEmpty ? "Untitled" : plan.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (_, _, completion) in
            guard let self else { return }
            if self.viewModel.canDeletePlan(at: indexPath.row) {
                self.viewModel.deletePlan(at: indexPath.row)
                completion(true)
            }
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension PlansListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let plan = viewModel.plans[indexPath.row]
        viewModel.select(plan: plan)
    }
}
