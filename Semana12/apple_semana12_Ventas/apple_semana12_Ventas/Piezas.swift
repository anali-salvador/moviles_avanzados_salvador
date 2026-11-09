import UIKit

/// Piezas visuales compartidas por las listas: cuadros con iniciales o ícono, píldoras y colores.
extension UI {

    /// Hasta dos iniciales de un nombre ("Lucía Pérez" → "LP").
    static func iniciales(de nombre: String?) -> String {
        let letras = (nombre ?? "").split(separator: " ").prefix(2)
            .compactMap { $0.first }.map(String.init).joined()
        return letras.isEmpty ? "?" : letras.uppercased()
    }

    /// Las dos primeras letras de un texto ("Laptop" → "LA").
    static func dosLetras(_ texto: String?) -> String {
        let letras = String((texto ?? "").filter { $0.isLetter || $0.isNumber }.prefix(2))
        return letras.isEmpty ? "?" : letras.uppercased()
    }

    /// Color fijo para un texto: el mismo nombre siempre da el mismo color.
    /// (No se usa hashValue porque cambia en cada ejecución.)
    static func colorFijo(para texto: String?) -> UIColor {
        let paleta: [UIColor] = [.systemBlue, .systemIndigo, .systemTeal, .systemOrange,
                                 .systemPink, .systemGreen, .systemPurple, .systemBrown]
        let suma = (texto ?? "").lowercased().unicodeScalars.reduce(0) { $0 &+ Int($1.value) }
        return paleta[suma % paleta.count]
    }

    /// Cuadrado redondeado de color con un texto blanco al centro.
    static func cuadroTexto(_ texto: String, fondo: UIColor, lado: CGFloat = 42) -> UIImage {
        UIGraphicsImageRenderer(size: CGSize(width: lado, height: lado)).image { _ in
            fondo.setFill()
            UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: lado, height: lado), cornerRadius: lado * 0.24).fill()
            let atributos: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: lado * 0.36, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            let tamano = (texto as NSString).size(withAttributes: atributos)
            (texto as NSString).draw(at: CGPoint(x: (lado - tamano.width) / 2, y: (lado - tamano.height) / 2),
                                     withAttributes: atributos)
        }.withRenderingMode(.alwaysOriginal)
    }

    /// Cuadrado redondeado de color con un SF Symbol al centro.
    static func cuadroIcono(_ simbolo: String, fondo: UIColor, color: UIColor = .white, lado: CGFloat = 42) -> UIImage {
        UIGraphicsImageRenderer(size: CGSize(width: lado, height: lado)).image { _ in
            fondo.setFill()
            UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: lado, height: lado), cornerRadius: lado * 0.24).fill()
            let configuracion = UIImage.SymbolConfiguration(pointSize: lado * 0.4, weight: .bold)
            guard let icono = UIImage(systemName: simbolo, withConfiguration: configuracion)?
                .withTintColor(color, renderingMode: .alwaysOriginal) else { return }
            let tamano = icono.size
            icono.draw(in: CGRect(x: (lado - tamano.width) / 2, y: (lado - tamano.height) / 2,
                                  width: tamano.width, height: tamano.height))
        }.withRenderingMode(.alwaysOriginal)
    }

    /// Píldora: fondo de color, texto (blanco por defecto) y bordes de cápsula.
    static func pastilla(_ texto: String, color: UIColor, textoColor: UIColor = .white,
                         fuente: UIFont = .systemFont(ofSize: 12, weight: .semibold)) -> UIView {
        let label = UILabel()
        label.text = texto
        label.font = fuente
        label.textColor = textoColor
        label.translatesAutoresizingMaskIntoConstraints = false

        let fondo = UIView()
        fondo.backgroundColor = color
        fondo.layer.cornerRadius = (fuente.lineHeight + 6) / 2
        fondo.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: fondo.topAnchor, constant: 3),
            label.bottomAnchor.constraint(equalTo: fondo.bottomAnchor, constant: -3),
            label.leadingAnchor.constraint(equalTo: fondo.leadingAnchor, constant: 9),
            label.trailingAnchor.constraint(equalTo: fondo.trailingAnchor, constant: -9)
        ])
        fondo.setContentHuggingPriority(.required, for: .horizontal)
        fondo.setContentCompressionResistancePriority(.required, for: .horizontal)
        return fondo
    }

    /// Pila vertical alineada a la derecha, con su tamaño ya calculado, lista para `accessoryView`.
    static func lateral(_ vistas: [UIView], espacio: CGFloat = 4) -> UIStackView {
        let pila = UIStackView(arrangedSubviews: vistas)
        pila.axis = .vertical
        pila.alignment = .trailing
        pila.spacing = espacio
        pila.frame.size = pila.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return pila
    }
}
