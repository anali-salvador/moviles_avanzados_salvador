import UIKit
import CoreData

/// Pantalla A1: login.
class LoginViewController: UIViewController {

    private let campoUsuario = UI.campo("Usuario")
    private let campoClave = UI.campo("Clave", oculto: true)
    private let labelError = UI.labelError()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let titulo = UILabel()
        titulo.text = "Ventas"
        titulo.font = .preferredFont(forTextStyle: .largeTitle).withSize(40)
        titulo.textAlignment = .center

        let botonIngresar = UI.boton("Ingresar")
        botonIngresar.addTarget(self, action: #selector(ingresar), for: .touchUpInside)

        let botonCrear = UI.boton("Crear cuenta", principal: false)
        botonCrear.addTarget(self, action: #selector(crearCuenta), for: .touchUpInside)

        let pila = UI.pila([titulo, campoUsuario, campoClave, labelError, botonIngresar, botonCrear], en: view)
        pila.setCustomSpacing(32, after: titulo)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc private func ingresar() {
        view.endEditing(true)
        let usuario = UI.texto(campoUsuario)
        let clave = campoClave.text ?? ""
        let mensaje = "Usuario o clave incorrectos"

        guard !usuario.isEmpty, !clave.isEmpty else {
            labelError.text = mensaje
            return
        }

        let pedido: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        pedido.predicate = NSPredicate(format: "usuario ==[c] %@", usuario)
        pedido.fetchLimit = 1

        guard let encontrado = try? UI.contexto.fetch(pedido).first,
              encontrado.clave == clave else {
            labelError.text = mensaje
            return
        }

        labelError.text = nil
        campoClave.text = nil
        Sesion.shared.usuarioActual = encontrado
        UI.cambiarRaiz(a: PrincipalViewController(), desde: view)
    }

    @objc private func crearCuenta() {
        labelError.text = nil
        navigationController?.pushViewController(RegistroViewController(), animated: true)
    }
}
