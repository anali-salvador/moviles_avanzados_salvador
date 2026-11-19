import UIKit
import CoreData

/// Pantalla A4: clientes.
/// Vendedor y Supervisor crean y editan; solo el Supervisor borra.
class ClientesViewController: UITableViewController {

    private let esSupervisor = Sesion.shared.usuarioActual?.rol == "Supervisor"

    private var clientes: [Cliente] = []
    private var textoBusqueda = ""

    private let buscador = UISearchController(searchResultsController: nil)
    private let labelVacio = UILabel()
    private let entrada = EntradaFilas()

    private var contexto: NSManagedObjectContext { UI.contexto }

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Clientes"
        tableView.prepararParaTarjetas()

        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por nombre o documento"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(agregar))

        labelVacio.text = "No hay clientes"
        labelVacio.font = Tema.fuente(16, .medium)
        labelVacio.textColor = Tema.textoSecundario
        labelVacio.textAlignment = .center

        tableView.tableFooterView = Tema.pieTabla(
            "Categoría y \"comprado\" se calculan con las ventas no anuladas; no se guardan.", ancho: view.bounds.width)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entrada.reiniciar()
        recargar()
    }

    // MARK: - Datos

    private func recargar() {
        let pedido: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        if !textoBusqueda.isEmpty {
            pedido.predicate = NSPredicate(format: "nombre CONTAINS[cd] %@ OR documento CONTAINS[cd] %@",
                                           textoBusqueda, textoBusqueda)
        }
        pedido.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true,
                                                   selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        pedido.relationshipKeyPathsForPrefetching = ["ventas"]

        clientes = (try? contexto.fetch(pedido)) ?? []
        tableView.backgroundView = clientes.isEmpty ? labelVacio : nil
        tableView.reloadData()
    }

    private func guardar() {
        do {
            try contexto.save()
        } catch {
            contexto.rollback()
            mostrarAviso("Error", "No se pudo guardar el cambio.")
        }
    }

    // MARK: - Tabla

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clientes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: CeldaTarjeta.id, for: indexPath) as! CeldaTarjeta
        let cliente = clientes[indexPath.row]
        let total = cliente.totalComprado()
        let categoria = cliente.categoria(para: total)

        celda.franja.backgroundColor = categoria.color
        celda.icono.image = UI.cuadroTexto(cliente.iniciales, fondo: categoria.color, lado: 44)
        celda.icono.layer.cornerRadius = 22
        celda.icono.clipsToBounds = true
        celda.titulo.text = cliente.nombre
        celda.subtitulo.text = "Doc: \(cliente.documento ?? "-")"

        let labelTotal = UILabel()
        labelTotal.text = UI.soles(total)
        labelTotal.font = Tema.numero(16, .bold)

        let labelComprado = UILabel()
        labelComprado.text = "comprado"
        labelComprado.font = Tema.fuente(12)
        labelComprado.textColor = Tema.textoSecundario

        let filaCategoria = UIStackView(arrangedSubviews: [
            labelComprado, UI.pastilla(categoria.rawValue, color: categoria.color)
        ])
        filaCategoria.spacing = 6
        filaCategoria.alignment = .center

        celda.ponerLateral([labelTotal, filaCategoria])
        return celda
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        entrada.aplicar(a: cell, en: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        mostrarFormulario(cliente: clientes[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        esSupervisor
    }

    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard esSupervisor else { return nil }
        let cliente = clientes[indexPath.row]
        let borrar = UIContextualAction(style: .destructive, title: "Borrar") { [weak self] _, _, terminar in
            self?.borrar(cliente)
            terminar(true)
        }
        borrar.backgroundColor = Tema.error
        borrar.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [borrar])
    }

    private func borrar(_ cliente: Cliente) {
        guard esSupervisor else { return }
        if (cliente.ventas?.count ?? 0) > 0 {
            mostrarAviso("No se puede borrar: el cliente tiene ventas", nil)
            recargar()
            return
        }
        contexto.delete(cliente)
        guardar()
        recargar()
    }

    // MARK: - Formulario (crear / editar)

    @objc private func agregar() {
        mostrarFormulario(cliente: nil)
    }

    /// Si la validación falla, se vuelve a mostrar con lo escrito y el error.
    private func mostrarFormulario(cliente: Cliente?, valores: [String]? = nil, error: String? = nil) {
        let alerta = UIAlertController(title: cliente == nil ? "Nuevo cliente" : "Editar cliente",
                                       message: error, preferredStyle: .alert)
        let iniciales = valores ?? [cliente?.nombre ?? "", cliente?.documento ?? ""]

        alerta.addTextField { $0.placeholder = "Nombre"; $0.text = iniciales[0]; $0.autocapitalizationType = .words }
        alerta.addTextField { $0.placeholder = "Documento"; $0.text = iniciales[1]; $0.keyboardType = .asciiCapable }

        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self, weak alerta] _ in
            let textos = (alerta?.textFields ?? []).map {
                ($0.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            }
            self?.guardarFormulario(cliente: cliente, textos: textos)
        })
        present(alerta, animated: true)
    }

    private func guardarFormulario(cliente: Cliente?, textos: [String]) {
        guard textos.count == 2 else { return }
        if textos.contains(where: { $0.isEmpty }) {
            mostrarFormulario(cliente: cliente, valores: textos, error: "Nombre y documento son obligatorios.")
            return
        }
        let destino = cliente ?? Cliente(context: contexto)
        destino.nombre = textos[0]
        destino.documento = textos[1]
        guardar()
        recargar()
    }

    private func mostrarAviso(_ titulo: String, _ mensaje: String?) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }

}

// MARK: - Búsqueda

extension ClientesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        textoBusqueda = (searchController.searchBar.text ?? "").trimmingCharacters(in: .whitespaces)
        recargar()
    }
}
