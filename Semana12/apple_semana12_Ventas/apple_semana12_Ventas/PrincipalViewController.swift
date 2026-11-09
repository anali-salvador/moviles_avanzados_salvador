import UIKit

/// Pantalla principal provisional (luego se reemplaza por las pestañas por rol).
class PrincipalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inicio"
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true

        let usuario = Sesion.shared.usuarioActual

        let labelNombre = UILabel()
        labelNombre.text = usuario?.nombre ?? "-"
        labelNombre.font = .preferredFont(forTextStyle: .title1)
        labelNombre.textAlignment = .center
        labelNombre.numberOfLines = 0

        let labelRol = UILabel()
        labelRol.text = "Rol: \(usuario?.rol ?? "-")"
        labelRol.font = .preferredFont(forTextStyle: .body)
        labelRol.textColor = .secondaryLabel
        labelRol.textAlignment = .center

        let botonCerrar = UI.boton("Cerrar sesión", principal: false)
        botonCerrar.addTarget(self, action: #selector(cerrarSesion), for: .touchUpInside)

        _ = UI.pila([labelNombre, labelRol, botonCerrar], en: view)
    }

    @objc private func cerrarSesion() {
        Sesion.shared.cerrar()
        UI.cambiarRaiz(a: LoginViewController(), desde: view)
    }
}
