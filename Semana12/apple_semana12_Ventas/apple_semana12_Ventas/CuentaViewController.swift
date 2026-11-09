import UIKit

/// Pestaña Cuenta: datos del usuario de la sesión y cierre de sesión.
class CuentaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let usuario = Sesion.shared.usuarioActual

        let labelNombre = UILabel()
        labelNombre.text = usuario?.nombre ?? "-"
        labelNombre.font = .preferredFont(forTextStyle: .title1)
        labelNombre.textAlignment = .center
        labelNombre.numberOfLines = 0

        let labelUsuario = dato("Usuario", usuario?.usuario)
        let labelRol = dato("Rol", usuario?.rol)

        let botonCerrar = UI.boton("Cerrar sesión", principal: false)
        botonCerrar.tintColor = .systemRed
        botonCerrar.addTarget(self, action: #selector(cerrarSesion), for: .touchUpInside)

        let pila = UI.pila([labelNombre, labelUsuario, labelRol, botonCerrar], en: view)
        pila.setCustomSpacing(32, after: labelRol)
    }

    private func dato(_ etiqueta: String, _ valor: String?) -> UILabel {
        let label = UILabel()
        label.text = "\(etiqueta): \(valor ?? "-")"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }

    @objc private func cerrarSesion() {
        Sesion.shared.cerrar()
        UI.cambiarRaiz(a: UINavigationController(rootViewController: LoginViewController()), desde: view)
    }
}
