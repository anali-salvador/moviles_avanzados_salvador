import UIKit
import CoreData

/// Pantalla A1: login.
class LoginViewController: UIViewController {

    private let campoUsuario = UI.campoTarjeta("Tu usuario")
    private let campoClave = UI.campoTarjeta("Tu clave", oculto: true)
    private let mensajeError = MensajeError()
    private var fondo: FondoAnimado!
    private let logo = LoginViewController.crearLogo()
    private var logoMostrado = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Tema.azulNoche
        fondo = agregarFondoAnimado()
        // Texto del botón de volver en la pantalla de registro.
        navigationItem.backButtonTitle = "Ingresar"

        let titulo = UILabel()
        titulo.text = "Ventas Tecsup"
        titulo.font = Tema.fuente(34, .heavy)
        titulo.textColor = .white
        titulo.textAlignment = .center

        let subtitulo = UILabel()
        subtitulo.text = "Inicia sesión para continuar"
        subtitulo.font = Tema.fuente(16, .medium)
        subtitulo.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitulo.textAlignment = .center

        campoUsuario.returnKeyType = .next
        campoClave.returnKeyType = .go
        campoUsuario.delegate = self
        campoClave.delegate = self

        let botonIngresar = Tema.botonAcento("Ingresar", icono: "arrow.right")
        botonIngresar.configuration?.imagePlacement = .trailing
        botonIngresar.addTarget(self, action: #selector(ingresar), for: .touchUpInside)

        let pila = UI.pila([
            Self.centrado(logo), titulo, subtitulo,
            UI.tarjetaCampo("Usuario", campoUsuario),
            UI.tarjetaCampo("Clave", campoClave),
            Self.centrado(mensajeError),
            botonIngresar,
            pieCrearCuenta()
        ], en: view)
        pila.spacing = 14
        pila.setCustomSpacing(20, after: pila.arrangedSubviews[0])
        pila.setCustomSpacing(4, after: titulo)
        pila.setCustomSpacing(32, after: subtitulo)
        pila.setCustomSpacing(22, after: pila.arrangedSubviews[4])
        pila.setCustomSpacing(22, after: pila.arrangedSubviews[5])
        pila.setCustomSpacing(16, after: botonIngresar)

        // El logo empieza oculto y entra con un rebote al abrir la pantalla.
        logo.alpha = 0
        logo.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fondo.iniciar()
        guard !logoMostrado else { return }
        logoMostrado = true
        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.6, options: []) {
            self.logo.alpha = 1
            self.logo.transform = .identity
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fondo.detener()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

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

    /// Círculo translúcido con borde claro y un carrito blanco.
    private static func crearLogo() -> UIView {
        let lado: CGFloat = 104
        let circulo = UIView()
        circulo.backgroundColor = UIColor.white.withAlphaComponent(0.14)
        circulo.layer.cornerRadius = lado / 2
        circulo.layer.borderWidth = 3
        circulo.layer.borderColor = UIColor.white.withAlphaComponent(0.75).cgColor
        circulo.sombra(color: .black, opacidad: 0.25, radio: 18, desplazamiento: 8)
        circulo.translatesAutoresizingMaskIntoConstraints = false

        let carrito = UIImageView(image: UIImage(systemName: "cart.fill"))
        carrito.tintColor = .white
        carrito.preferredSymbolConfiguration = .init(pointSize: 42, weight: .semibold)
        carrito.translatesAutoresizingMaskIntoConstraints = false
        circulo.addSubview(carrito)

        NSLayoutConstraint.activate([
            circulo.widthAnchor.constraint(equalToConstant: lado),
            circulo.heightAnchor.constraint(equalToConstant: lado),
            carrito.centerXAnchor.constraint(equalTo: circulo.centerXAnchor, constant: -2),
            carrito.centerYAnchor.constraint(equalTo: circulo.centerYAnchor)
        ])
        return circulo
    }

    /// "¿Primera vez? Crear cuenta", con "Crear cuenta" como botón.
    private func pieCrearCuenta() -> UIView {
        let pregunta = UILabel()
        pregunta.text = "¿Primera vez?"
        pregunta.font = Tema.fuente(15, .medium)
        pregunta.textColor = UIColor.white.withAlphaComponent(0.8)

        var config = UIButton.Configuration.plain()
        config.title = "Crear cuenta"
        config.baseForegroundColor = .white
        config.contentInsets = .init(top: 6, leading: 2, bottom: 6, trailing: 2)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
            var nuevos = atributos
            nuevos.font = Tema.fuente(15, .bold)
            nuevos.underlineStyle = NSUnderlineStyle.single
            return nuevos
        }
        let boton = UIButton(configuration: config)
        boton.addTarget(self, action: #selector(crearCuenta), for: .touchUpInside)

        let fila = UIStackView(arrangedSubviews: [pregunta, boton])
        fila.spacing = 4
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
