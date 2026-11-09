import UIKit
import CoreData

/// Pantalla A3: catálogo de productos.
/// Supervisor: crea, edita y borra. Vendedor: solo consulta y busca.
class ProductosViewController: UITableViewController {

    private let celdaId = "ProductoCelda"
    private let esSupervisor = Sesion.shared.usuarioActual?.rol == "Supervisor"

    private var productos: [Producto] = []
    private var categorias: [String] = []
    private var categoriaSeleccionada: String?   // nil = "Todas"
    private var textoBusqueda = ""

    private let buscador = UISearchController(searchResultsController: nil)
    private let pilaChips = UIStackView()
    private let labelVacio = UILabel()

    private var contexto: NSManagedObjectContext { UI.contexto }

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Productos"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: celdaId)

        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por nombre"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        if esSupervisor {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add, target: self, action: #selector(agregar))
        }

        configurarChips()

        labelVacio.text = "No hay productos"
        labelVacio.textColor = .secondaryLabel
        labelVacio.textAlignment = .center
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recargar()
    }

    // MARK: - Datos

    /// Vuelve a leer categorías y productos (con búsqueda y filtro) y recarga la tabla.
    private func recargar() {
        cargarCategorias()

        let pedido: NSFetchRequest<Producto> = Producto.fetchRequest()
        var condiciones: [NSPredicate] = []
        if !textoBusqueda.isEmpty {
            condiciones.append(NSPredicate(format: "nombre CONTAINS[cd] %@", textoBusqueda))
        }
        if let categoria = categoriaSeleccionada {
            condiciones.append(NSPredicate(format: "categoria ==[c] %@", categoria))
        }
        pedido.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: condiciones)
        pedido.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true,
                                                   selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]

        productos = (try? contexto.fetch(pedido)) ?? []
        tableView.backgroundView = productos.isEmpty ? labelVacio : nil
        tableView.reloadData()
    }

    private func cargarCategorias() {
        let pedido: NSFetchRequest<Producto> = Producto.fetchRequest()
        let todos = (try? contexto.fetch(pedido)) ?? []
        var vistas = Set<String>()
        var nuevas: [String] = []
        for producto in todos {
            let categoria = (producto.categoria ?? "").trimmingCharacters(in: .whitespaces)
            guard !categoria.isEmpty, vistas.insert(categoria.lowercased()).inserted else { continue }
            nuevas.append(categoria)
        }
        nuevas.sort { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }

        if let seleccionada = categoriaSeleccionada,
           !nuevas.contains(where: { $0.caseInsensitiveCompare(seleccionada) == .orderedSame }) {
            categoriaSeleccionada = nil
        }
        if nuevas != categorias || pilaChips.arrangedSubviews.isEmpty {
            categorias = nuevas
            dibujarChips()
        } else {
            actualizarEstadoChips()
        }
    }

    private func guardar() -> Bool {
        do {
            try contexto.save()
            return true
        } catch {
            contexto.rollback()
            mostrarAviso("Error", "No se pudo guardar el cambio.")
            return false
        }
    }

    // MARK: - Chips de categoría

    private func configurarChips() {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false

        pilaChips.axis = .horizontal
        pilaChips.spacing = 8
        pilaChips.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(pilaChips)

        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 52))
        contenedor.addSubview(scroll)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: contenedor.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: contenedor.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor),
            pilaChips.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 16),
            pilaChips.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -16),
            pilaChips.centerYAnchor.constraint(equalTo: scroll.frameLayoutGuide.centerYAnchor),
            pilaChips.heightAnchor.constraint(equalToConstant: 34)
        ])
        tableView.tableHeaderView = contenedor
    }

    private func dibujarChips() {
        pilaChips.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (indice, nombre) in (["Todas"] + categorias).enumerated() {
            let chip = UIButton(configuration: .gray())
            chip.configuration?.title = nombre
            chip.configuration?.cornerStyle = .capsule
            chip.tag = indice
            chip.addTarget(self, action: #selector(elegirCategoria(_:)), for: .touchUpInside)
            pilaChips.addArrangedSubview(chip)
        }
        actualizarEstadoChips()
    }

    private func actualizarEstadoChips() {
        for case let chip as UIButton in pilaChips.arrangedSubviews {
            let nombre: String? = chip.tag == 0 ? nil : categorias[chip.tag - 1]
            let activo = nombre?.lowercased() == categoriaSeleccionada?.lowercased()
            chip.configuration?.baseBackgroundColor = activo ? .systemBlue : .systemGray5
            chip.configuration?.baseForegroundColor = activo ? .white : .label
        }
    }

    @objc private func elegirCategoria(_ chip: UIButton) {
        categoriaSeleccionada = chip.tag == 0 ? nil : categorias[chip.tag - 1]
        recargar()
    }

    // MARK: - Tabla

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: celdaId, for: indexPath)
        let producto = productos[indexPath.row]

        var contenido = UIListContentConfiguration.subtitleCell()
        contenido.text = producto.nombre
        contenido.secondaryText = "\(producto.categoria ?? "-")  ·  \(Self.formatoPrecio(producto.precio))"
        contenido.secondaryTextProperties.color = .secondaryLabel
        celda.contentConfiguration = contenido

        let labelStock = UILabel()
        labelStock.text = "Stock: \(producto.stock)"
        labelStock.font = .preferredFont(forTextStyle: .subheadline).withSize(15)
        labelStock.textColor = Self.colorStock(producto.stock)
        labelStock.sizeToFit()
        celda.accessoryView = labelStock

        celda.selectionStyle = esSupervisor ? .default : .none
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard esSupervisor else { return }
        mostrarFormulario(producto: productos[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        esSupervisor
    }

    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard esSupervisor else { return nil }
        let borrar = UIContextualAction(style: .destructive, title: "Borrar") { [weak self] _, _, terminar in
            self?.borrar(self?.productos[indexPath.row])
            terminar(true)
        }
        return UISwipeActionsConfiguration(actions: [borrar])
    }

    private func borrar(_ producto: Producto?) {
        guard let producto else { return }
        if (producto.ventas?.count ?? 0) > 0 {
            mostrarAviso("No se puede borrar: el producto tiene ventas", nil)
            recargar()
            return
        }
        contexto.delete(producto)
        _ = guardar()
        recargar()
    }

    // MARK: - Formulario (crear / editar)

    @objc private func agregar() {
        mostrarFormulario(producto: nil)
    }

    /// Muestra el formulario. Si la validación falla, se vuelve a mostrar con lo escrito y el error.
    private func mostrarFormulario(producto: Producto?, valores: [String]? = nil, error: String? = nil) {
        let alerta = UIAlertController(title: producto == nil ? "Nuevo producto" : "Editar producto",
                                       message: error, preferredStyle: .alert)
        let iniciales = valores ?? [
            producto?.nombre ?? "",
            producto?.categoria ?? "",
            producto.map { String(format: "%.2f", $0.precio) } ?? "",
            producto.map { String($0.stock) } ?? ""
        ]

        alerta.addTextField { $0.placeholder = "Nombre"; $0.text = iniciales[0]; $0.autocapitalizationType = .sentences }
        alerta.addTextField { $0.placeholder = "Categoría"; $0.text = iniciales[1]; $0.autocapitalizationType = .sentences }
        alerta.addTextField { $0.placeholder = "Precio"; $0.text = iniciales[2]; $0.keyboardType = .decimalPad }
        alerta.addTextField { $0.placeholder = "Stock"; $0.text = iniciales[3]; $0.keyboardType = .numberPad }

        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self, weak alerta] _ in
            let textos = (alerta?.textFields ?? []).map {
                ($0.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            }
            self?.guardarFormulario(producto: producto, textos: textos)
        })
        present(alerta, animated: true)
    }

    private func guardarFormulario(producto: Producto?, textos: [String]) {
        guard textos.count == 4 else { return }
        let (nombre, categoria, textoPrecio, textoStock) = (textos[0], textos[1], textos[2], textos[3])

        let error: String?
        let precio = Double(textoPrecio.replacingOccurrences(of: ",", with: "."))
        let stock = Int32(textoStock)
        if textos.contains(where: { $0.isEmpty }) {
            error = "Todos los campos son obligatorios."
        } else if precio == nil || !(precio!.isFinite) || precio! <= 0 {
            error = "El precio debe ser un número mayor a 0."
        } else if stock == nil || stock! < 0 {
            error = "El stock debe ser un número entero de 0 o más."
        } else {
            error = nil
        }

        if let error {
            mostrarFormulario(producto: producto, valores: textos, error: error)
            return
        }

        let destino = producto ?? Producto(context: contexto)
        destino.nombre = nombre
        destino.categoria = categoria
        destino.precio = precio!
        destino.stock = stock!
        _ = guardar()
        recargar()
    }

    private func mostrarAviso(_ titulo: String, _ mensaje: String?) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }

    // MARK: - Formato

    static func formatoPrecio(_ precio: Double) -> String {
        UI.soles(precio)
    }

    static func colorStock(_ stock: Int32) -> UIColor {
        switch stock {
        case ...5: return .systemRed
        case 6...10: return .systemOrange
        default: return .systemGreen
        }
    }
}

// MARK: - Búsqueda

extension ProductosViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        textoBusqueda = (searchController.searchBar.text ?? "").trimmingCharacters(in: .whitespaces)
        recargar()
    }
}
