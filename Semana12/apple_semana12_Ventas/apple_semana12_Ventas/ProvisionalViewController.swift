import UIKit

/// Pantalla provisional para las pestañas que aún no están construidas.
class ProvisionalViewController: UIViewController {

    private let titulo: String

    init(titulo: String) {
        self.titulo = titulo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) no se usa")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = titulo
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
