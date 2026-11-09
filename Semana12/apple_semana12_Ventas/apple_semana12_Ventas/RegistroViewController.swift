import UIKit
import CoreData

/// Pantalla A2: registro de usuario.
class RegistroViewController: UIViewController {

    private let campoNombre = UI.campoTarjeta("Ej. Lucía Pérez")
    private let campoUsuario = UI.campoTarjeta("Ej. lperez")
    private let campoClave = UI.campoTarjeta("Mínimo 6 caracteres", oculto: true)
    private let campoConfirmar = UI.campoTarjeta("Repite la clave", oculto: true)
    private let selectorRol = UISegmentedControl(items: ["Vendedor", "Supervisor"])
    private let avisoUsuario = UILabel()
    private let mensajeError = MensajeError()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crear cuenta"
        view.backgroundColor = .systemGroupedBackground

        campoNombre.autocapitalizationType = .words
        selectorRol.selectedSegmentIndex = 0

        avisoUsuario.font = .systemFont(ofSize: 12, weight: .semibold)
        avisoUsuario.textAlignment = .right
        campoUsuario.addTarget(self, action: #selector(usuarioCambio), for: .editingChanged)

        let campos = [campoNombre, campoUsuario, campoClave, campoConfirmar]
        for campo in campos {
            campo.delegate = self
            campo.returnKeyType = campo === campoConfirmar ? .done : .next
        }

        let botonRegistrar = UI.botonPrincipal("Registrarme")
        botonRegistrar.addTarget(self, action: #selector(registrar), for: .touchUpInside)

        let nota = UILabel()
        nota.text = "Al registrarte entrarás directamente a la app con las pestañas de tu rol."
        nota.font = .preferredFont(forTextStyle: .footnote)
        nota.textColor = .secondaryLabel
        nota.textAlignment = .center
        nota.numberOfLines = 0

        let etiquetaRol = UI.etiquetaSeccion("Tu rol")
        let tarjetaConfirmar = UI.tarjetaCampo("Confirmar clave", campoConfirmar)

        let pila = UI.pila([
            UI.tarjetaCampo("Nombre completo", campoNombre),
            UI.tarjetaCampo("Usuario", campoUsuario, accesorio: avisoUsuario),
            UI.tarjetaCampo("Clave (mínimo 6 caracteres)", campoClave),
            tarjetaConfirmar,
            etiquetaRol, selectorRol,
            LoginViewController.centrado(mensajeError),
            botonRegistrar, nota
        ], en: view)
        pila.spacing = 12
        pila.setCustomSpacing(20, after: tarjetaConfirmar)
        pila.setCustomSpacing(6, after: etiquetaRol)
        pila.setCustomSpacing(20, after: selectorRol)
    }

    // MARK: - Aviso en vivo

    /// "✓ Disponible" en verde, "Ese usuario ya existe" en rojo, o nada si está vacío.
    @objc private func usuarioCambio() {
        let usuario = UI.texto(campoUsuario)
        if usuario.isEmpty {
            avisoUsuario.text = nil
        } else if existeUsuario(usuario) {
            avisoUsuario.text = "Ese usuario ya existe"
            avisoUsuario.textColor = .systemRed
        } else {
            avisoUsuario.text = "✓ Disponible"
            avisoUsuario.textColor = .systemGreen
        }
    }

    /// Usuario único sin distinguir mayúsculas.
    private func existeUsuario(_ usuario: String) -> Bool {
        let pedido: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        pedido.predicate = NSPredicate(format: "usuario ==[c] %@", usuario)
        return ((try? UI.contexto.count(for: pedido)) ?? 0) > 0
    }

    // MARK: - Registrar (mismas validaciones y mensajes)

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
        guard !existeUsuario(usuario) else {
            return mostrarError("Ese usuario ya existe")
        }

        let contexto = UI.contexto
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
        mensajeError.texto = mensaje
    }
}

extension RegistroViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let orden = [campoNombre, campoUsuario, campoClave, campoConfirmar]
        if let indice = orden.firstIndex(where: { $0 === textField }), indice + 1 < orden.count {
            orden[indice + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
