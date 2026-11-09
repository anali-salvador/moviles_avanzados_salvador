import UIKit
import CoreData

/// Pantalla A7: todas las ventas del equipo (Supervisor), con anulación (A8).
class VentasEquipoViewController: UIViewController {

    private enum Periodo: Int { case todas, hoy, mes }

    private let celdaId = "VentaEquipoCelda"
    private var ventas: [Venta] = []
    private var vendedores: [Usuario] = []
    private var vendedorSeleccionado: Usuario?   // nil = "Todos"
    private var textoBusqueda = ""

    private let selectorPeriodo = UISegmentedControl(items: ["Todas", "Hoy", "Mes"])
    private let pilaChips = UIStackView()
    private let barraBusqueda = UISearchBar()
    private let tabla = UITableView(frame: .zero, style: .insetGrouped)
    private let labelVacio = UILabel()

    private var contexto: NSManagedObjectContext { UI.contexto }
    private var esSupervisor: Bool { Sesion.shared.usuarioActual?.rol == "Supervisor" }

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ventas"
        view.backgroundColor = .systemGroupedBackground

        // Iniciales del usuario de la sesión, solo informativas.
        let iniciales = UILabel()
        iniciales.text = UI.iniciales(de: Sesion.shared.usuarioActual?.nombre)
        iniciales.font = .systemFont(ofSize: 17, weight: .semibold)
        iniciales.textColor = .systemBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: iniciales)

        selectorPeriodo.selectedSegmentIndex = Periodo.todas.rawValue
        selectorPeriodo.addTarget(self, action: #selector(cambioFiltro), for: .valueChanged)

        let scrollChips = UIScrollView()
        scrollChips.showsHorizontalScrollIndicator = false
        scrollChips.translatesAutoresizingMaskIntoConstraints = false
        pilaChips.axis = .horizontal
        pilaChips.spacing = 8
        pilaChips.translatesAutoresizingMaskIntoConstraints = false
        scrollChips.addSubview(pilaChips)

        barraBusqueda.searchBarStyle = .minimal
        barraBusqueda.placeholder = "Buscar por cliente"
        barraBusqueda.autocapitalizationType = .none
        barraBusqueda.delegate = self

        let filtros = UIStackView(arrangedSubviews: [selectorPeriodo, scrollChips, barraBusqueda])
        filtros.axis = .vertical
        filtros.spacing = 10
        filtros.setCustomSpacing(2, after: scrollChips)
        filtros.translatesAutoresizingMaskIntoConstraints = false

        tabla.translatesAutoresizingMaskIntoConstraints = false
        tabla.dataSource = self
        tabla.delegate = self
        tabla.allowsSelection = false
        tabla.keyboardDismissMode = .onDrag
        tabla.register(UITableViewCell.self, forCellReuseIdentifier: celdaId)

        view.addSubview(filtros)
        view.addSubview(tabla)
        let guia = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            filtros.topAnchor.constraint(equalTo: guia.topAnchor, constant: 8),
            filtros.leadingAnchor.constraint(equalTo: guia.leadingAnchor, constant: 16),
            filtros.trailingAnchor.constraint(equalTo: guia.trailingAnchor, constant: -16),

            scrollChips.heightAnchor.constraint(equalToConstant: 36),
            pilaChips.leadingAnchor.constraint(equalTo: scrollChips.contentLayoutGuide.leadingAnchor),
            pilaChips.trailingAnchor.constraint(equalTo: scrollChips.contentLayoutGuide.trailingAnchor),
            pilaChips.topAnchor.constraint(equalTo: scrollChips.contentLayoutGuide.topAnchor),
            pilaChips.bottomAnchor.constraint(equalTo: scrollChips.contentLayoutGuide.bottomAnchor),
            pilaChips.heightAnchor.constraint(equalTo: scrollChips.frameLayoutGuide.heightAnchor),

            tabla.topAnchor.constraint(equalTo: filtros.bottomAnchor),
            tabla.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabla.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabla.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        labelVacio.text = "No hay ventas"
        labelVacio.textColor = .secondaryLabel
        labelVacio.textAlignment = .center
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recargar()
    }

    // MARK: - Datos

    private func inicioPeriodo() -> Date? {
        let ahora = Date()
        switch Periodo(rawValue: selectorPeriodo.selectedSegmentIndex) ?? .todas {
        case .todas: return nil
        case .hoy: return Calendar.current.startOfDay(for: ahora)
        case .mes: return Calendar.current.dateInterval(of: .month, for: ahora)?.start
        }
    }

    /// Periodo, vendedor y cliente se combinan con AND.
    private func recargar() {
        cargarVendedores()

        var condiciones: [NSPredicate] = []
        if let desde = inicioPeriodo() {
            condiciones.append(NSPredicate(format: "fecha >= %@", desde as NSDate))
        }
        if let vendedor = vendedorSeleccionado {
            condiciones.append(NSPredicate(format: "vendedor == %@", vendedor))
        }
        if !textoBusqueda.isEmpty {
            condiciones.append(NSPredicate(format: "cliente.nombre CONTAINS[cd] %@", textoBusqueda))
        }

        let pedido: NSFetchRequest<Venta> = Venta.fetchRequest()
        pedido.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: condiciones)
        pedido.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
        pedido.relationshipKeyPathsForPrefetching = ["vendedor", "cliente", "producto"]
        ventas = (try? contexto.fetch(pedido)) ?? []

        tabla.backgroundView = ventas.isEmpty ? labelVacio : nil
        tabla.reloadData()
    }

    /// Usuarios que tienen al menos una venta, para los chips.
    private func cargarVendedores() {
        let pedido: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        pedido.predicate = NSPredicate(format: "ventas.@count > 0")
        pedido.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true,
                                                   selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        let nuevos = (try? contexto.fetch(pedido)) ?? []

        if let seleccionado = vendedorSeleccionado, !nuevos.contains(seleccionado) {
            vendedorSeleccionado = nil
        }
        if nuevos != vendedores || pilaChips.arrangedSubviews.isEmpty {
            vendedores = nuevos
            dibujarChips()
        } else {
            actualizarEstadoChips()
        }
    }

    @objc private func cambioFiltro() {
        recargar()
    }

    // MARK: - Chips

    private func dibujarChips() {
        pilaChips.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let nombres = ["Todos"] + vendedores.map { $0.nombre ?? $0.usuario ?? "-" }
        for (indice, nombre) in nombres.enumerated() {
            var config = UIButton.Configuration.filled()
            config.title = nombre
            config.cornerStyle = .capsule
            config.contentInsets = .init(top: 6, leading: 14, bottom: 6, trailing: 14)
            let chip = UIButton(configuration: config)
            chip.tag = indice
            chip.addTarget(self, action: #selector(elegirVendedor(_:)), for: .touchUpInside)
            pilaChips.addArrangedSubview(chip)
        }
        actualizarEstadoChips()
    }

    private func actualizarEstadoChips() {
        for case let chip as UIButton in pilaChips.arrangedSubviews {
            let vendedor: Usuario? = chip.tag == 0 ? nil : vendedores[chip.tag - 1]
            let activo = vendedor == vendedorSeleccionado
            chip.configuration?.baseBackgroundColor = activo ? .systemBlue : .systemGray5
            chip.configuration?.baseForegroundColor = activo ? .white : .label
        }
    }

    @objc private func elegirVendedor(_ chip: UIButton) {
        vendedorSeleccionado = chip.tag == 0 ? nil : vendedores[chip.tag - 1]
        recargar()
    }

    // MARK: - Anular (pantalla A8)

    /// Pide el motivo; el botón "Anular" solo se activa cuando hay texto.
    private func pedirAnulacion(de venta: Venta) {
        guard esSupervisor, !venta.anulada else { return }

        let mensaje = """
        \(venta.cliente?.nombre ?? "-") · \(venta.producto?.nombre ?? "-") × \(venta.cantidad) · \(UI.soles(venta.total))
        El stock se devolverá (+\(venta.cantidad))
        """
        let alerta = UIAlertController(title: "Anular venta", message: mensaje, preferredStyle: .alert)
        var observador: NSObjectProtocol?
        let quitarObservador = {
            if let observador { NotificationCenter.default.removeObserver(observador) }
            observador = nil
        }

        alerta.addTextField { $0.placeholder = "Motivo (obligatorio)"; $0.autocapitalizationType = .sentences }
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { _ in quitarObservador() })
        let accionAnular = UIAlertAction(title: "Anular", style: .destructive) { [weak self, weak alerta] _ in
            quitarObservador()
            let motivo = (alerta?.textFields?.first?.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            self?.anular(venta, motivo: motivo)
        }
        accionAnular.isEnabled = false
        alerta.addAction(accionAnular)

        if let campo = alerta.textFields?.first {
            observador = NotificationCenter.default.addObserver(
                forName: UITextField.textDidChangeNotification, object: campo, queue: .main
            ) { [weak accionAnular] _ in
                let texto = (campo.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                accionAnular?.isEnabled = !texto.isEmpty
            }
        }
        present(alerta, animated: true)
    }

    /// Marca la venta como anulada, guarda el motivo y devuelve el stock.
    private func anular(_ venta: Venta, motivo: String) {
        guard esSupervisor, !venta.anulada, !motivo.isEmpty else { return }

        venta.anulada = true
        venta.motivoAnulacion = motivo
        if let producto = venta.producto {
            producto.stock += venta.cantidad
        }

        do {
            try contexto.save()
        } catch {
            contexto.rollback()
            let aviso = UIAlertController(title: "No se pudo anular la venta",
                                          message: error.localizedDescription, preferredStyle: .alert)
            aviso.addAction(UIAlertAction(title: "Aceptar", style: .default))
            present(aviso, animated: true)
        }
        recargar()
    }

    // MARK: - Ayudas

    static func texto(_ texto: String, tachado: Bool, fuente: UIFont, color: UIColor) -> NSAttributedString {
        var atributos: [NSAttributedString.Key: Any] = [.font: fuente, .foregroundColor: color]
        if tachado {
            atributos[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        return NSAttributedString(string: texto, attributes: atributos)
    }
}

// MARK: - Tabla

extension VentasEquipoViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ventas.count
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "El nombre del vendedor se lee de la relación venta ▸ vendedor."
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: celdaId, for: indexPath)
        let venta = ventas[indexPath.row]
        let anulada = venta.anulada
        let cliente = venta.cliente

        let primerNombreVendedor = (venta.vendedor?.nombre ?? venta.vendedor?.usuario ?? "-")
            .split(separator: " ").first.map(String.init) ?? "-"
        let detalle = "\(primerNombreVendedor) · \(venta.producto?.nombre ?? "-") × \(venta.cantidad)"

        var contenido = UIListContentConfiguration.subtitleCell()
        let categoria = cliente?.categoria() ?? .regular
        contenido.image = UI.cuadroTexto(cliente?.iniciales ?? "?", fondo: categoria.color)
        contenido.imageProperties.maximumSize = CGSize(width: 42, height: 42)
        contenido.imageToTextPadding = 12

        contenido.attributedText = Self.texto(cliente?.nombre ?? "-", tachado: anulada,
                                              fuente: .systemFont(ofSize: 16, weight: .semibold),
                                              color: anulada ? .secondaryLabel : .label)

        let cuerpo = UIFont.preferredFont(forTextStyle: .subheadline)
        let secundario = NSMutableAttributedString(
            attributedString: Self.texto(detalle, tachado: anulada, fuente: cuerpo, color: .secondaryLabel))
        if anulada {
            secundario.append(Self.texto("\nMotivo: \(venta.motivoAnulacion ?? "-")", tachado: false,
                                         fuente: .preferredFont(forTextStyle: .footnote), color: .systemGray))
        }
        contenido.secondaryAttributedText = secundario
        contenido.textToSecondaryTextVerticalPadding = 3
        celda.contentConfiguration = contenido

        let labelTotal = UILabel()
        labelTotal.attributedText = Self.texto(UI.soles(venta.total), tachado: anulada,
                                               fuente: .monospacedDigitSystemFont(ofSize: 16, weight: .bold),
                                               color: anulada ? .secondaryLabel : .label)
        let lateral = UIStackView(arrangedSubviews: [labelTotal])
        lateral.axis = .vertical
        lateral.alignment = .trailing
        lateral.spacing = 3
        if anulada {
            let etiqueta = UILabel()
            etiqueta.text = "ANULADA"
            etiqueta.font = .systemFont(ofSize: 11, weight: .bold)
            etiqueta.textColor = .systemRed
            lateral.addArrangedSubview(etiqueta)
        }
        lateral.frame.size = lateral.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        celda.accessoryView = lateral
        return celda
    }

    /// Solo ventas no anuladas tienen la acción "Anular".
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let venta = ventas[indexPath.row]
        guard esSupervisor, !venta.anulada else { return nil }

        let anular = UIContextualAction(style: .destructive, title: "Anular") { [weak self] _, _, terminar in
            self?.pedirAnulacion(de: venta)
            terminar(true)
        }
        anular.backgroundColor = .systemRed
        let configuracion = UISwipeActionsConfiguration(actions: [anular])
        configuracion.performsFirstActionWithFullSwipe = false
        return configuracion
    }
}

// MARK: - Búsqueda

extension VentasEquipoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textoBusqueda = searchText.trimmingCharacters(in: .whitespaces)
        recargar()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
