import UIKit
import CoreData

/// Pantalla A7: todas las ventas del equipo (Supervisor), con anulación (A8).
class VentasEquipoViewController: UIViewController {

    private enum Periodo: Int { case todas, hoy, mes }

    private var ventas: [Venta] = []
    private var vendedores: [Usuario] = []
    private var vendedorSeleccionado: Usuario?   // nil = "Todos"
    private var textoBusqueda = ""

    private let selectorPeriodo = UISegmentedControl(items: ["Todas", "Hoy", "Mes"])
    private let pilaChips = UIStackView()
    private let barraBusqueda = UISearchBar()
    private let tabla = UITableView(frame: .zero, style: .plain)
    private let labelVacio = UILabel()
    private let entrada = EntradaFilas()
    private let valorFiltrado = UILabel()
    private let detalleFiltrado = UILabel()

    private var contexto: NSManagedObjectContext { UI.contexto }
    private var esSupervisor: Bool { Sesion.shared.usuarioActual?.rol == "Supervisor" }

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ventas"
        view.backgroundColor = Tema.fondo

        // Iniciales del usuario de la sesión, solo informativas.
        navigationItem.rightBarButtonItem = MisVentasViewController.botonAvatar(Sesion.shared.usuarioActual?.nombre)

        selectorPeriodo.selectedSegmentIndex = Periodo.todas.rawValue
        Tema.estilizar(selectorPeriodo)
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

        let resumen = tarjetaResumen()
        let filtros = UIStackView(arrangedSubviews: [resumen, selectorPeriodo, scrollChips, barraBusqueda])
        filtros.axis = .vertical
        filtros.spacing = 10
        filtros.setCustomSpacing(14, after: resumen)
        filtros.setCustomSpacing(2, after: scrollChips)
        filtros.translatesAutoresizingMaskIntoConstraints = false

        tabla.translatesAutoresizingMaskIntoConstraints = false
        tabla.dataSource = self
        tabla.delegate = self
        tabla.allowsSelection = false
        tabla.keyboardDismissMode = .onDrag
        tabla.prepararParaTarjetas()
        tabla.tableFooterView = Tema.pieTabla("El nombre del vendedor se lee de la relación venta ▸ vendedor.",
                                              ancho: view.bounds.width)

        view.addSubview(filtros)
        view.addSubview(tabla)
        let guia = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            filtros.topAnchor.constraint(equalTo: guia.topAnchor, constant: 8),
            filtros.leadingAnchor.constraint(equalTo: guia.leadingAnchor, constant: Tema.margen),
            filtros.trailingAnchor.constraint(equalTo: guia.trailingAnchor, constant: -Tema.margen),

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
        labelVacio.font = Tema.fuente(16, .medium)
        labelVacio.textColor = Tema.textoSecundario
        labelVacio.textAlignment = .center

        Tema.animarEntrada([resumen, selectorPeriodo, scrollChips])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entrada.reiniciar()
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
        mostrarResumen()
    }

    // MARK: - Resumen (solo muestra lo que ya está en la lista)

    /// Tarjeta con degradado: total de las ventas vigentes de la lista filtrada.
    private func tarjetaResumen() -> UIView {
        let etiqueta = UILabel()
        etiqueta.text = "TOTAL DEL FILTRO"
        etiqueta.font = Tema.fuente(12, .bold)
        etiqueta.textColor = UIColor.white.withAlphaComponent(0.85)

        valorFiltrado.font = Tema.numero(26, .heavy)
        valorFiltrado.textColor = .white
        valorFiltrado.adjustsFontSizeToFitWidth = true
        valorFiltrado.minimumScaleFactor = 0.6

        detalleFiltrado.font = Tema.fuente(13, .semibold)
        detalleFiltrado.textColor = UIColor.white.withAlphaComponent(0.85)

        let textos = UIStackView(arrangedSubviews: [etiqueta, valorFiltrado, detalleFiltrado])
        textos.axis = .vertical
        textos.spacing = 2

        let icono = UIImageView(image: UIImage(systemName: "chart.line.uptrend.xyaxis"))
        icono.tintColor = .white
        icono.preferredSymbolConfiguration = .init(pointSize: 30, weight: .semibold)
        icono.alpha = 0.9
        icono.setContentHuggingPriority(.required, for: .horizontal)

        let fila = UIStackView(arrangedSubviews: [textos, icono])
        fila.alignment = .center
        fila.spacing = 12
        return Tema.tarjetaDegradado(fila, relleno: 16)
    }

    private func mostrarResumen() {
        let vigentes = ventas.filter { !$0.anulada }
        let anuladas = ventas.count - vigentes.count
        valorFiltrado.text = UI.soles(CalculoVenta.redondear(vigentes.reduce(0) { $0 + $1.total }))
        let texto = vigentes.count == 1 ? "1 venta vigente" : "\(vigentes.count) ventas vigentes"
        detalleFiltrado.text = anuladas > 0 ? "\(texto) · \(anuladas) anulada\(anuladas == 1 ? "" : "s")" : texto
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
            let chip = Tema.chip(nombre)
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
            Tema.marcar(chip: chip, activo: activo)
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: CeldaTarjeta.id, for: indexPath) as! CeldaTarjeta
        let venta = ventas[indexPath.row]
        let anulada = venta.anulada
        let cliente = venta.cliente

        let primerNombreVendedor = (venta.vendedor?.nombre ?? venta.vendedor?.usuario ?? "-")
            .split(separator: " ").first.map(String.init) ?? "-"
        let detalle = "\(primerNombreVendedor) · \(venta.producto?.nombre ?? "-") × \(venta.cantidad)"

        let categoria = cliente?.categoria() ?? .regular
        celda.franja.backgroundColor = anulada ? Tema.error : Tema.principal
        celda.icono.image = UI.cuadroTexto(cliente?.iniciales ?? "?", fondo: categoria.color, lado: 44)
        celda.icono.alpha = anulada ? 0.5 : 1

        celda.titulo.attributedText = Self.texto(cliente?.nombre ?? "-", tachado: anulada,
                                                 fuente: Tema.fuente(16, .semibold),
                                                 color: anulada ? Tema.textoSecundario : .label)

        let secundario = NSMutableAttributedString(
            attributedString: Self.texto(detalle, tachado: anulada, fuente: Tema.fuente(13), color: Tema.textoSecundario))
        if anulada {
            secundario.append(Self.texto("\nMotivo: \(venta.motivoAnulacion ?? "-")", tachado: false,
                                         fuente: Tema.fuente(12, .medium), color: Tema.tono(Tema.error)))
        }
        celda.subtitulo.attributedText = secundario

        let labelTotal = UILabel()
        labelTotal.attributedText = Self.texto(UI.soles(venta.total), tachado: anulada,
                                               fuente: Tema.numero(16, .bold),
                                               color: anulada ? Tema.textoSecundario : Tema.principal)
        var lateral: [UIView] = [labelTotal]
        if anulada {
            lateral.append(UI.pastilla("ANULADA", color: Tema.error, fuente: Tema.fuente(11, .heavy)))
        }
        celda.ponerLateral(lateral)
        return celda
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        entrada.aplicar(a: cell, en: indexPath)
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
        anular.backgroundColor = Tema.error
        anular.image = UIImage(systemName: "xmark.circle.fill")
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
