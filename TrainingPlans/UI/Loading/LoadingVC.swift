import UIKit

final class LoadingVC: UIViewController {
    private lazy var activity = UIActivityIndicatorView(style: .large)
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("loading_title", comment: "")
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(activity)
        view.addSubview(titleLabel)
        
        activity.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: activity.bottomAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        activity.startAnimating()
    }
}
