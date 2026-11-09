import UIKit
import CoreData

enum UI {
    static var contexto: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    static func campo(_ placeholder: String, oculto: Bool = false) -> UITextField {
        let campo = UITextField()
        campo.placeholder = placeholder
        campo.borderStyle = .roundedRect
        campo.autocapitalizationType = .none
        campo.autocorrectionType = .no
        campo.isSecureTextEntry = oculto
        if oculto { campo.textContentType = .oneTimeCode }
        campo.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return campo
    }

    static func boton(_ titulo: String, principal: Bool = true) -> UIButton {
        var config: UIButton.Configuration = principal ? .filled() : .plain()
        config.title = titulo
        let boton = UIButton(configuration: config)
        boton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return boton
    }

    static func labelError() -> UILabel {
        let label = UILabel()
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }

    static func pila(_ vistas: [UIView], en vista: UIView) -> UIStackView {
        let pila = UIStackView(arrangedSubviews: vistas)
        pila.axis = .vertical
        pila.spacing = 12
        pila.translatesAutoresizingMaskIntoConstraints = false

        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.keyboardDismissMode = .interactive
        vista.addSubview(scroll)
        scroll.addSubview(pila)

        let guia = vista.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: guia.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: vista.keyboardLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: guia.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: guia.trailingAnchor),
            pila.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 32),
            pila.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            pila.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 24),
            pila.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -24)
        ])
        return pila
    }

    static func texto(_ campo: UITextField) -> String {
        (campo.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Reemplaza la raíz de la ventana (login <-> app) para no apilar pantallas.
    static func cambiarRaiz(a controlador: UIViewController, desde vista: UIView) {
        guard let ventana = vista.window else { return }
        ventana.rootViewController = UINavigationController(rootViewController: controlador)
        UIView.transition(with: ventana, duration: 0.25, options: .transitionCrossDissolve, animations: nil)
    }
}
