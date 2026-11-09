import UIKit
import CoreData

/// Pantalla A1: login.
class LoginViewController: UIViewController {

    private let campoUsuario = UI.campoTarjeta("Tu usuario")
    private let campoClave = UI.campoTarjeta("Tu clave", oculto: true)
    private let mensajeError = MensajeError()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        // Texto del botón de volver en la pantalla de registro.
        navigationItem.backButtonTitle = "Ingresar"

        let titulo = UILabel()
        titulo.text = "Ventas Tecsup"
        titulo.font = .systemFont(ofSize: 30, weight: .bold)
        titulo.textAlignment = .center

        let subtitulo = UILabel()
        subtitulo.text = "Inicia sesión para continuar"
        subtitulo.font = .preferredFont(forTextStyle: .subheadline)
        subtitulo.textColor = .secondaryLabel
        subtitulo.textAlignment = .center

        campoUsuario.returnKeyType = .next
        campoClave.returnKeyType = .go
        campoUsuario.delegate = self
        campoClave.delegate = self

        let botonIngresar = UI.botonPrincipal("Ingresar")
        botonIngresar.addTarget(self, action: #selector(ingresar), for: .touchUpInside)

        let pila = UI.pila([
            Self.logo(), titulo, subtitulo,
            UI.tarjetaCampo("Usuario", campoUsuario),
            UI.tarjetaCampo("Clave", campoClave),
            Self.centrado(mensajeError),
            botonIngresar,
            pieCrearCuenta()
        ], en: view)
        pila.spacing = 12
        pila.setCustomSpacing(16, after: pila.arrangedSubviews[0])
        pila.setCustomSpacing(4, after: titulo)
        pila.setCustomSpacing(28, after: subtitulo)
        pila.setCustomSpacing(16, after: botonIngresar)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Acciones (la lógica no cambia)

    @objc private func ingresar() {
        view.endEditing(true)
        let usuario = UI.texto(campoUsuario)
        let clave = campoClave.text ?? ""
        let mensaje = "Usuario o clave incorrectos"

        guard !usuario.isEmpty, !clave.isEmpty else {
            mensajeError.texto = mensaje
            return
        }

        let pedido: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        pedido.predicate = NSPredicate(format: "usuario ==[c] %@", usuario)
        pedido.fetchLimit = 1

        guard let encontrado = try? UI.contexto.fetch(pedido).first,
              encontrado.clave == clave else {
            mensajeError.texto = mensaje
            return
        }

        mensajeError.texto = nil
        campoClave.text = nil
        Sesion.shared.usuarioActual = encontrado
        UI.cambiarRaiz(a: PrincipalViewController(), desde: view)
    }

    @objc private func crearCuenta() {
        mensajeError.texto = nil
        navigationController?.pushViewController(RegistroViewController(), animated: true)
    }

    // MARK: - Vistas

    /// Cuadrado azul redondeado con un carrito blanco.
    private static func logo() -> UIView {
        let cuadro = UIView()
        cuadro.backgroundColor = .systemBlue
        cuadro.layer.cornerRadius = 22
        cuadro.translatesAutoresizingMaskIntoConstraints = false

        let carrito = UIImageView(image: UIImage(systemName: "cart.fill"))
        carrito.tintColor = .white
        carrito.preferredSymbolConfiguration = .init(pointSize: 40, weight: .semibold)
        carrito.translatesAutoresizingMaskIntoConstraints = false
        cuadro.addSubview(carrito)

        NSLayoutConstraint.activate([
            cuadro.widthAnchor.constraint(equalToConstant: 90),
            cuadro.heightAnchor.constraint(equalToConstant: 90),
            carrito.centerXAnchor.constraint(equalTo: cuadro.centerXAnchor),
            carrito.centerYAnchor.constraint(equalTo: cuadro.centerYAnchor)
        ])
        return centrado(cuadro)
    }

    /// "¿Primera vez? Crear cuenta", con "Crear cuenta" como botón.
    private func pieCrearCuenta() -> UIView {
        let pregunta = UILabel()
        pregunta.text = "¿Primera vez?"
        pregunta.font = .preferredFont(forTextStyle: .subheadline)
        pregunta.textColor = .secondaryLabel

        var config = UIButton.Configuration.plain()
        config.title = "Crear cuenta"
        config.contentInsets = .init(top: 6, leading: 2, bottom: 6, trailing: 2)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
            var nuevos = atributos
            nuevos.font = .systemFont(ofSize: 15, weight: .bold)
            return nuevos
        }
        let boton = UIButton(configuration: config)
        boton.addTarget(self, action: #selector(crearCuenta), for: .touchUpInside)

        let fila = UIStackView(arrangedSubviews: [pregunta, boton])
        fila.spacing = 2
        fila.alignment = .center
        return Self.centrado(fila)
    }

    /// Envuelve una vista para centrarla horizontalmente dentro de la pila.
    static func centrado(_ vista: UIView) -> UIView {
        let contenedor = UIView()
        vista.translatesAutoresizingMaskIntoConstraints = false
        contenedor.addSubview(vista)
        NSLayoutConstraint.activate([
            vista.topAnchor.constraint(equalTo: contenedor.topAnchor),
            vista.bottomAnchor.constraint(equalTo: contenedor.bottomAnchor),
            vista.centerXAnchor.constraint(equalTo: contenedor.centerXAnchor),
            vista.leadingAnchor.constraint(greaterThanOrEqualTo: contenedor.leadingAnchor),
            vista.trailingAnchor.constraint(lessThanOrEqualTo: contenedor.trailingAnchor)
        ])
        // El contenedor se oculta junto con la vista (para el mensaje de error).
        if let error = vista as? MensajeError {
            contenedor.isHidden = error.isHidden
            error.alCambiarVisibilidad = { [weak contenedor] oculto in contenedor?.isHidden = oculto }
        }
        return contenedor
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === campoUsuario {
            campoClave.becomeFirstResponder()
        } else {
            ingresar()
        }
        return true
    }
}
