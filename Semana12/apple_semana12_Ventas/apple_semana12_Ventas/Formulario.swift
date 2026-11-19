import UIKit

/// Piezas visuales de los formularios de login y registro.
extension UI {

    /// Campo sin borde, para ir dentro de una tarjeta.
    static func campoTarjeta(_ placeholder: String, oculto: Bool = false) -> UITextField {
        let campo = UITextField()
        campo.placeholder = placeholder
        campo.font = Tema.fuente(17, .medium)
        campo.tintColor = Tema.principalOscuro
        campo.borderStyle = .none
        campo.autocapitalizationType = .none
        campo.autocorrectionType = .no
        campo.clearButtonMode = .whileEditing
        campo.isSecureTextEntry = oculto
        if oculto { campo.textContentType = .oneTimeCode }
        campo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return campo
    }

    /// Tarjeta blanca semitransparente (va sobre el fondo animado): etiqueta arriba y el campo debajo.
    /// `accesorio` va a la derecha de la etiqueta (por ejemplo, el aviso de disponibilidad).
    static func tarjetaCampo(_ etiqueta: String, _ campo: UITextField, accesorio: UIView? = nil) -> UIView {
        let titulo = Tema.etiqueta(etiqueta, color: Tema.principalOscuro)

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
            interior.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 12),
            interior.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -10),
            interior.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 18),
            interior.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -18)
        ])
        // Tocar cualquier parte de la tarjeta enfoca el campo.
        tarjeta.addGestureRecognizer(UITapGestureRecognizer(target: campo, action: #selector(UIResponder.becomeFirstResponder)))
        return tarjeta
    }

    /// Etiqueta pequeña en mayúsculas (estilo del tema).
    static func etiquetaSeccion(_ texto: String) -> UILabel {
        Tema.etiqueta(texto)
    }

    /// Botón principal con degradado teal.
    static func botonPrincipal(_ titulo: String) -> UIButton {
        Tema.botonPrincipal(titulo)
    }
}

/// Tarjeta blanca semitransparente con borde claro, para ir sobre el fondo animado.
/// Siempre usa el estilo claro para que el texto oscuro se lea igual en modo oscuro.
final class TarjetaConBorde: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        overrideUserInterfaceStyle = .light
        backgroundColor = UIColor.white.withAlphaComponent(0.9)
        layer.cornerRadius = Tema.radio
        layer.cornerCurve = .continuous
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        sombra(color: .black, opacidad: 0.12, radio: 16, desplazamiento: 8)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }
}

/// Mensaje de error en rojo con ícono de alerta, dentro de una cápsula clara para leerse
/// sobre el fondo animado. Se oculta cuando no hay texto.
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
        icono.tintColor = Tema.error
        icono.preferredSymbolConfiguration = .init(pointSize: 14, weight: .semibold)
        icono.setContentHuggingPriority(.required, for: .horizontal)

        label.textColor = Tema.error
        label.font = Tema.fuente(14, .semibold)
        label.numberOfLines = 0

        addArrangedSubview(icono)
        addArrangedSubview(label)
        spacing = 6
        alignment = .center
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = .init(top: 8, leading: 14, bottom: 8, trailing: 16)
        overrideUserInterfaceStyle = .light
        backgroundColor = UIColor.white.withAlphaComponent(0.92)
        layer.cornerRadius = 18
        layer.cornerCurve = .continuous
        isHidden = true
    }

    required init(coder: NSCoder) { fatalError("init(coder:) no se usa") }
}
