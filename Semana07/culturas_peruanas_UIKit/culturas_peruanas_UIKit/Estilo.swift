import UIKit

extension UIColor {

    convenience init(hex: UInt32) {
        let rojo = CGFloat((hex >> 16) & 0xFF) / 255
        let verde = CGFloat((hex >> 8) & 0xFF) / 255
        let azul = CGFloat(hex & 0xFF) / 255
        self.init(red: rojo, green: verde, blue: azul, alpha: 1)
    }

    static let vino = UIColor(hex: 0x7B2D26)
    static let terracota = UIColor(hex: 0xC1663A)
    static let dorado = UIColor(hex: 0xD9A441)
    static let crema = UIColor(hex: 0xFAF3E7)
    static let marronOscuro = UIColor(hex: 0x3A2A21)
    static let grisCalido = UIColor(hex: 0x8A7A6E)
}

enum Estilo {

    // Fondo blanco con esquinas redondeadas y separado de los bordes, para que cada fila se vea como tarjeta
    static func fondoTarjeta() -> UIBackgroundConfiguration {
        var fondo = UIBackgroundConfiguration.listPlainCell()
        fondo.backgroundColor = .white
        fondo.cornerRadius = 16
        fondo.backgroundInsets = NSDirectionalEdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16)
        return fondo
    }

    // Flechita ">" en dorado
    static func flechita() -> UIImageView {
        let configuracion = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let flecha = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: configuracion))
        flecha.tintColor = .dorado
        flecha.sizeToFit()
        return flecha
    }

    // Aplica el estilo de tarjeta a una celda: fondo, márgenes y flechita
    static func aplicarTarjeta(a celda: UITableViewCell) {
        celda.backgroundConfiguration = fondoTarjeta()
        celda.selectionStyle = .none
        celda.preservesSuperviewLayoutMargins = false
        celda.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32)
        celda.accessoryView = flechita()
    }
}
