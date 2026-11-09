import UIKit

/// Datos calculados del cliente (no se guardan en Core Data).
extension Cliente {

    enum Categoria: String {
        case regular = "Regular"
        case frecuente = "Frecuente"
        case vip = "VIP"

        var color: UIColor {
            switch self {
            case .regular: return .systemGray
            case .frecuente: return .systemBlue
            case .vip: return .systemPurple
            }
        }
    }

    /// Suma del total de las ventas no anuladas de este cliente.
    func totalComprado() -> Double {
        let ventas = (self.ventas as? Set<Venta>) ?? []
        return ventas.filter { !$0.anulada }.reduce(0) { $0 + $1.total }
    }

    /// Regular < 1000, Frecuente desde 1000, VIP desde 5000.
    func categoria() -> Categoria {
        categoria(para: totalComprado())
    }

    func categoria(para total: Double) -> Categoria {
        switch total {
        case 5000...: return .vip
        case 1000...: return .frecuente
        default: return .regular
        }
    }

    /// Hasta dos iniciales del nombre, en mayúsculas.
    var iniciales: String {
        let partes = (nombre ?? "").split(separator: " ").prefix(2)
        let letras = partes.compactMap { $0.first }.map { String($0) }.joined()
        return letras.isEmpty ? "?" : letras.uppercased()
    }
}
