
import UIKit

class VentaModel: NSObject {

    var subtotal: Double = 0
    var igv: Double = 0
    var base: Double = 0
    var intereses: Double = 0
    var total: Double = 0
    var cuota: Double = 0

    // Inicializador sin parámetros y con parámetros
    override init() {
        self.subtotal = 0
        self.igv = 0
        self.base = 0
        self.intereses = 0
        self.total = 0
        self.cuota = 0
    }

    init(subtotal: Double, igv: Double, base: Double, intereses: Double, total: Double, cuota: Double) {
        self.subtotal = subtotal
        self.igv = igv
        self.base = base
        self.intereses = intereses
        self.total = total
        self.cuota = cuota
    }
}
