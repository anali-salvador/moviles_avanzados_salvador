import Foundation

/// Cálculo de una venta. Todos los montos se redondean a 2 decimales.
struct CalculoVenta {
    static let tasaDescuentoVIP = 0.10
    static let tasaIGV = 0.18

    let precioUnitario: Double
    let subtotal: Double
    let descuento: Double
    let igv: Double
    let total: Double

    /// - subtotal = cantidad x precio
    /// - descuento = 10% del subtotal solo si el cliente es VIP
    /// - igv = 18% sobre (subtotal - descuento)
    /// - total = subtotal - descuento + igv
    init(cantidad: Int, precio: Double, esVIP: Bool) {
        precioUnitario = Self.redondear(precio)
        subtotal = Self.redondear(Double(cantidad) * precioUnitario)
        descuento = esVIP ? Self.redondear(subtotal * Self.tasaDescuentoVIP) : 0
        igv = Self.redondear((subtotal - descuento) * Self.tasaIGV)
        total = Self.redondear(subtotal - descuento + igv)
    }

    static func redondear(_ valor: Double) -> Double {
        (valor * 100).rounded(.toNearestOrAwayFromZero) / 100
    }
}
