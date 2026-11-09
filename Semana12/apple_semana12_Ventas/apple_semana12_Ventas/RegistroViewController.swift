import UIKit
import CoreData

/// Pantalla A2: registro de usuario.
class RegistroViewController: UIViewController {

    private let campoNombre = UI.campo("Nombre completo")
    private let campoUsuario = UI.campo("Usuario")
    private let campoClave = UI.campo("Clave", oculto: true)
    private let campoConfirmar = UI.campo("Confirmar clave", oculto: true)
    private let selectorRol = UISegmentedControl(items: ["Vendedor", "Supervisor"])
    private let labelError = UI.labelError()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crear cuenta"
        view.backgroundColor = .systemBackground

        campoNombre.autocapitalizationType = .words
        selectorRol.selectedSegmentIndex = 0

        let botonRegistrar = UI.boton("Registrarme")
        botonRegistrar.addTarget(self, action: #selector(registrar), for: .touchUpInside)

        _ = UI.pila([campoNombre, campoUsuario, campoClave, campoConfirmar,
                     selectorRol, labelError, botonRegistrar], en: view)
    }

    @objc private func registrar() {
        view.endEditing(true)
        let nombre = UI.texto(campoNombre)
        let usuario = UI.texto(campoUsuario)
        let clave = campoClave.text ?? ""
        let confirmar = campoConfirmar.text ?? ""

        guard !nombre.isEmpty, !usuario.isEmpty, !clave.isEmpty, !confirmar.isEmpty else {
            return mostrarError("Todos los campos son obligatorios")
        }
        guard clave.count >= 6 else {
            return mostrarError("La clave debe tener al menos 6 caracteres")
        }
        guard clave == confirmar else {
            return mostrarError("Las claves no coinciden")
        }

        let contexto = UI.contexto
        let pedido: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        pedido.predicate = NSPredicate(format: "usuario ==[c] %@", usuario)
        let existentes = (try? contexto.count(for: pedido)) ?? 0
        guard existentes == 0 else {
            return mostrarError("Ese usuario ya existe")
        }

        let nuevo = Usuario(context: contexto)
        nuevo.nombre = nombre
        nuevo.usuario = usuario
        nuevo.clave = clave
        nuevo.rol = selectorRol.titleForSegment(at: selectorRol.selectedSegmentIndex)

        do {
            try contexto.save()
        } catch {
            contexto.delete(nuevo)
            return mostrarError("No se pudo crear la cuenta. Intenta de nuevo.")
        }

        Sesion.shared.usuarioActual = nuevo
        UI.cambiarRaiz(a: PrincipalViewController(), desde: view)
    }

    private func mostrarError(_ mensaje: String) {
        labelError.text = mensaje
    }
}
