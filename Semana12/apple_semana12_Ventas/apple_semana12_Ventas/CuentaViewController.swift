import UIKit

/// Pestaña Cuenta: datos del usuario de la sesión y cierre de sesión.
class CuentaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Tema.fondo

        let usuario = Sesion.shared.usuarioActual

        let labelNombre = UILabel()
        labelNombre.text = usuario?.nombre ?? "-"
        labelNombre.font = Tema.fuente(24, .heavy)
        labelNombre.textAlignment = .center
        labelNombre.numberOfLines = 0

        let labelUsuario = UILabel()
        labelUsuario.text = "@\(usuario?.usuario ?? "-")"
        labelUsuario.font = Tema.fuente(15, .medium)
        labelUsuario.textColor = Tema.textoSecundario
        labelUsuario.textAlignment = .center

        let perfil = UIStackView(arrangedSubviews: [
            LoginViewController.centrado(avatar(usuario?.nombre)), labelNombre, labelUsuario,
            LoginViewController.centrado(Tema.pildora(usuario?.rol ?? "-", color: Tema.principal,
                                                      fuente: Tema.fuente(13, .bold)))
        ])
        perfil.axis = .vertical
        perfil.spacing = 6
        perfil.setCustomSpacing(14, after: perfil.arrangedSubviews[0])
        perfil.setCustomSpacing(12, after: labelUsuario)

        let datos = UIStackView(arrangedSubviews: [
            dato("Usuario", usuario?.usuario, icono: "person.fill"),
            dato("Rol", usuario?.rol, icono: "briefcase.fill")
        ])
        datos.axis = .vertical
        datos.spacing = 14

        let botonCerrar = Tema.botonSuave("Cerrar sesión", icono: "rectangle.portrait.and.arrow.right",
                                          color: Tema.error)
        botonCerrar.addTarget(self, action: #selector(cerrarSesion), for: .touchUpInside)

        let tarjetaPerfil = Tema.tarjeta(perfil, relleno: 24)
        let tarjetaDatos = Tema.tarjeta(datos, relleno: 18)
        let pila = UI.pila([tarjetaPerfil, Tema.etiqueta("Datos de la cuenta"), tarjetaDatos, botonCerrar], en: view)
        pila.spacing = 16
        pila.setCustomSpacing(24, after: tarjetaPerfil)
        pila.setCustomSpacing(6, after: pila.arrangedSubviews[1])
        pila.setCustomSpacing(32, after: tarjetaDatos)
        Tema.animarEntrada(pila.arrangedSubviews)
    }

    /// Avatar circular con degradado teal y las iniciales.
    private func avatar(_ nombre: String?) -> UIView {
        let lado: CGFloat = 92
        let circulo = VistaDegradado(colores: Tema.degradadoTeal)
        circulo.layer.cornerRadius = lado / 2
        circulo.layer.borderWidth = 4
        circulo.layer.borderColor = UIColor.white.withAlphaComponent(0.85).cgColor
        circulo.sombra(color: Tema.principalOscuro, opacidad: 0.3, radio: 12, desplazamiento: 6)

        let iniciales = UILabel()
        iniciales.text = UI.iniciales(de: nombre)
        iniciales.font = Tema.fuente(34, .heavy)
        iniciales.textColor = .white
        iniciales.translatesAutoresizingMaskIntoConstraints = false
        circulo.addSubview(iniciales)
        NSLayoutConstraint.activate([
            circulo.widthAnchor.constraint(equalToConstant: lado),
            circulo.heightAnchor.constraint(equalToConstant: lado),
            iniciales.centerXAnchor.constraint(equalTo: circulo.centerXAnchor),
            iniciales.centerYAnchor.constraint(equalTo: circulo.centerYAnchor)
        ])
        return circulo
    }

    private func dato(_ etiqueta: String, _ valor: String?, icono: String) -> UIView {
        let titulo = Tema.etiqueta(etiqueta)
        let texto = UILabel()
        texto.text = valor ?? "-"
        texto.font = Tema.fuente(17, .semibold)

        let textos = UIStackView(arrangedSubviews: [titulo, texto])
        textos.axis = .vertical
        textos.spacing = 2

        let fila = UIStackView(arrangedSubviews: [Tema.icono(icono, lado: 38), textos])
        fila.spacing = 12
        fila.alignment = .center
        return fila
    }

    @objc private func cerrarSesion() {
        Sesion.shared.cerrar()
        UI.cambiarRaiz(a: UINavigationController(rootViewController: LoginViewController()), desde: view)
    }
}
