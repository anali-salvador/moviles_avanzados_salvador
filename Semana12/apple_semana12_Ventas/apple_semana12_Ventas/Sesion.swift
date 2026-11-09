import Foundation

final class Sesion {
    static let shared = Sesion()

    var usuarioActual: Usuario?

    private init() {}

    func cerrar() {
        usuarioActual = nil
    }
}
