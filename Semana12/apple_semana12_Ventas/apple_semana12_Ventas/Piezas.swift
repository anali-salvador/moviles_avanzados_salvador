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
        let paleta: [UIColor] = [Tema.principalOscuro, Tema.principalClaro, Tema.acento, Tema.exito,
                                 Tema.aviso, UIColor(hex: 0x0E7490), UIColor(hex: 0x7C3AED), UIColor(hex: 0x475569)]
        let suma = (texto ?? "").lowercased().unicodeScalars.reduce(0) { $0 &+ Int($1.value) }
        return paleta[suma % paleta.count]
    }

    /// Cuadrado redondeado de color con un texto blanco al centro.
    static func cuadroTexto(_ texto: String, fondo: UIColor, lado: CGFloat = 42) -> UIImage {
        UIGraphicsImageRenderer(size: CGSize(width: lado, height: lado)).image { _ in
            fondo.setFill()
            UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: lado, height: lado), cornerRadius: lado * 0.32).fill()
            let atributos: [NSAttributedString.Key: Any] = [
                .font: Tema.fuente(lado * 0.36, .bold),
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
            UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: lado, height: lado), cornerRadius: lado * 0.32).fill()
            let configuracion = UIImage.SymbolConfiguration(pointSize: lado * 0.4, weight: .bold)
            guard let icono = UIImage(systemName: simbolo, withConfiguration: configuracion)?
                .withTintColor(color, renderingMode: .alwaysOriginal) else { return }
            let tamano = icono.size
            icono.draw(in: CGRect(x: (lado - tamano.width) / 2, y: (lado - tamano.height) / 2,
                                  width: tamano.width, height: tamano.height))
        }.withRenderingMode(.alwaysOriginal)
    }

    /// Píldora suave con la paleta del tema.
    static func pastilla(_ texto: String, color: UIColor,
                         fuente: UIFont = Tema.fuente(12, .bold)) -> UIView {
        Tema.pildora(texto, color: color, fuente: fuente)
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
