import UIKit

/// Piezas visuales de los formularios de login y registro.
extension UI {

    /// Campo sin borde, para ir dentro de una tarjeta.
    static func campoTarjeta(_ placeholder: String, oculto: Bool = false) -> UITextField {
        let campo = UITextField()
        campo.placeholder = placeholder
        campo.font = .preferredFont(forTextStyle: .body)
        campo.borderStyle = .none
        campo.autocapitalizationType = .none
        campo.autocorrectionType = .no
        campo.clearButtonMode = .whileEditing
        campo.isSecureTextEntry = oculto
        if oculto { campo.textContentType = .oneTimeCode }
        campo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return campo
    }

    /// Tarjeta blanca con borde suave: etiqueta pequeña en mayúsculas arriba y el campo debajo.
    /// `accesorio` va a la derecha de la etiqueta (por ejemplo, el aviso de disponibilidad).
    static func tarjetaCampo(_ etiqueta: String, _ campo: UITextField, accesorio: UIView? = nil) -> UIView {
        let titulo = etiquetaSeccion(etiqueta)

        let cabecera = UIStackView(arrangedSubviews: [titulo])
        cabecera.spacing = 8
        if let accesorio {
            accesorio.setContentHuggingPriority(.required, for: .horizontal)
            accesorio.setContentCompressionResistancePriority(.required, for: .horizontal)
            cabecera.addArrangedSubview(accesorio)
        }

        let interior = UIStackView(arrangedSubviews: [cabecera, campo])
        interior.axis = .vertical
        interior.spacing = 4
        interior.translatesAutoresizingMaskIntoConstraints = false

        let tarjeta = TarjetaConBorde()
        tarjeta.addSubview(interior)
        NSLayoutConstraint.activate([
            interior.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 10),
            interior.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -8),
            interior.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 14),
            interior.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -14)
        ])
        // Tocar cualquier parte de la tarjeta enfoca el campo.
        tarjeta.addGestureRecognizer(UITapGestureRecognizer(target: campo, action: #selector(UIResponder.becomeFirstResponder)))
        return tarjeta
    }

    /// Etiqueta pequeña, gris y en mayúsculas.
    static func etiquetaSeccion(_ texto: String) -> UILabel {
        let label = UILabel()
        label.text = texto.uppercased()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }

    /// Botón azul de ancho completo con esquinas redondeadas.
    static func botonPrincipal(_ titulo: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = titulo
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
            var nuevos = atributos
            nuevos.font = .systemFont(ofSize: 17, weight: .semibold)
            return nuevos
        }
        let boton = UIButton(configuration: config)
        boton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return boton
    }
}

/// Tarjeta blanca con borde suave que se adapta al modo oscuro.
final class TarjetaConBorde: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 12
        layer.borderWidth = 1
        actualizarBorde()
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (vista: TarjetaConBorde, _) in
            vista.actualizarBorde()
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    private func actualizarBorde() {
        layer.borderColor = UIColor.separator.resolvedColor(with: traitCollection).cgColor
    }
}

/// Mensaje de error en rojo con ícono de alerta. Se oculta cuando no hay texto.
final class MensajeError: UIStackView {
    private let label = UILabel()

    /// Avisa cuando se muestra u oculta (útil si va dentro de un contenedor).
    var alCambiarVisibilidad: ((Bool) -> Void)?

    var texto: String? {
        get { label.text }
        set {
            label.text = newValue
            isHidden = (newValue ?? "").isEmpty
            alCambiarVisibilidad?(isHidden)
        }
    }

    init() {
        super.init(frame: .zero)
        let icono = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        icono.tintColor = .systemRed
        icono.preferredSymbolConfiguration = .init(pointSize: 14, weight: .semibold)
        icono.setContentHuggingPriority(.required, for: .horizontal)

        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0

        addArrangedSubview(icono)
        addArrangedSubview(label)
        spacing = 6
        alignment = .center
        isHidden = true
    }

    required init(coder: NSCoder) { fatalError("init(coder:) no se usa") }
}
