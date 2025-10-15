//
//  PlanDetailVC.swift
//  TrainingPlans
//
//  Created by Никита Гуляев on 06.10.2025.
//

import UIKit

final class PlanDetailVC: UIViewController {
    private let viewModel: PlanDetailVM
    private lazy var label = UILabel()

    init(viewModel: PlanDetailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "План"
        view.backgroundColor = .white
        
        label.text = "План: \(viewModel.plan.title)"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Старт",
            style: .done,
            target: self,
            action: #selector(startTapped))
    }

    @objc private func startTapped() {
        viewModel.startTapped()
    }
}
