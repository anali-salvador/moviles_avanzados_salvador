import UIKit
import CoreData

/// Pantalla A6: ventas del vendedor de la sesión (solo consulta, no puede anular).
class MisVentasViewController: UIViewController {

    private enum Periodo: Int { case todas, hoy, mes }

    private let celdaId = "VentaCelda"
    private var ventas: [Venta] = []
    private var textoBusqueda = ""

    private let valorHoy = UILabel()
    private let valorMes = UILabel()
    private let cantidadHoy = UILabel()
    private let cantidadMes = UILabel()
    private let selectorPeriodo = UISegmentedControl(items: ["Todas", "Hoy", "Mes"])
    private let tabla = UITableView(frame: .zero, style: .insetGrouped)
    private let buscador = UISearchController(searchResultsController: nil)
    private let labelVacio = UILabel()

    private let formatoFecha: DateFormatter = {
        let formato = DateFormatter()
        formato.dateFormat = "dd/MM"
        return formato
    }()

    private var contexto: NSManagedObjectContext { UI.contexto }

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mis ventas"
        view.backgroundColor = .systemGroupedBackground

        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por cliente"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        // Iniciales del vendedor de la sesión, solo informativas.
        let iniciales = UILabel()
        iniciales.text = UI.iniciales(de: Sesion.shared.usuarioActual?.nombre)
        iniciales.font = .systemFont(ofSize: 17, weight: .semibold)
        iniciales.textColor = .systemBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: iniciales)

        let indicadores = UIStackView(arrangedSubviews: [
            tarjeta("Hoy", valorHoy, cantidadHoy), tarjeta("Mes", valorMes, cantidadMes)
        ])
        indicadores.spacing = 12
        indicadores.distribution = .fillEqually

        selectorPeriodo.selectedSegmentIndex = Periodo.todas.rawValue
        selectorPeriodo.addTarget(self, action: #selector(cambioPeriodo), for: .valueChanged)

        let cabecera = UIStackView(arrangedSubviews: [indicadores, selectorPeriodo])
        cabecera.axis = .vertical
        cabecera.spacing = 12
        cabecera.translatesAutoresizingMaskIntoConstraints = false

        tabla.translatesAutoresizingMaskIntoConstraints = false
        tabla.dataSource = self
        tabla.allowsSelection = false
        tabla.register(UITableViewCell.self, forCellReuseIdentifier: celdaId)

        view.addSubview(cabecera)
        view.addSubview(tabla)
        let guia = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            cabecera.topAnchor.constraint(equalTo: guia.topAnchor, constant: 8),
            cabecera.leadingAnchor.constraint(equalTo: guia.leadingAnchor, constant: 20),
            cabecera.trailingAnchor.constraint(equalTo: guia.trailingAnchor, constant: -20),
            tabla.topAnchor.constraint(equalTo: cabecera.bottomAnchor, constant: 4),
            tabla.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabla.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabla.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        labelVacio.textColor = .secondaryLabel
        labelVacio.textAlignment = .center
        labelVacio.numberOfLines = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recargar()
    }

    // MARK: - Consultas

    /// Todas las consultas parten de aquí: solo ventas del vendedor de la sesión.
    private func predicadoVendedor() -> NSPredicate {
        guard let usuario = Sesion.shared.usuarioActual else { return NSPredicate(value: false) }
        return NSPredicate(format: "vendedor == %@", usuario)
    }

    private func inicio(de periodo: Periodo) -> Date? {
        let calendario = Calendar.current
        let ahora = Date()
        switch periodo {
        case .todas: return nil
        case .hoy: return calendario.startOfDay(for: ahora)
        case .mes: return calendario.dateInterval(of: .month, for: ahora)?.start
        }
    }

    private func recargar() {
        let hoy = vendido(desde: inicio(de: .hoy))
        let mes = vendido(desde: inicio(de: .mes))
        valorHoy.text = UI.soles(hoy.total)
        valorMes.text = UI.soles(mes.total)
        cantidadHoy.text = Self.textoCantidad(hoy.cantidad)
        cantidadMes.text = Self.textoCantidad(mes.cantidad)

        var condiciones = [predicadoVendedor()]
        if let desde = inicio(de: Periodo(rawValue: selectorPeriodo.selectedSegmentIndex) ?? .todas) {
            condiciones.append(NSPredicate(format: "fecha >= %@", desde as NSDate))
        }
        if !textoBusqueda.isEmpty {
            condiciones.append(NSPredicate(format: "cliente.nombre CONTAINS[cd] %@", textoBusqueda))
        }

        let pedido: NSFetchRequest<Venta> = Venta.fetchRequest()
        pedido.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: condiciones)
        pedido.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
        pedido.relationshipKeyPathsForPrefetching = ["cliente", "producto"]
        ventas = (try? contexto.fetch(pedido)) ?? []

        if ventas.isEmpty {
            labelVacio.text = tieneVentas() ? "No hay ventas con este filtro" : "Aún no tienes ventas"
            tabla.backgroundView = labelVacio
        } else {
            tabla.backgroundView = nil
        }
        tabla.reloadData()
    }

    /// Total y cantidad de ventas no anuladas del vendedor desde una fecha.
    private func vendido(desde: Date?) -> (total: Double, cantidad: Int) {
        var condiciones = [predicadoVendedor(), NSPredicate(format: "anulada == NO")]
        if let desde {
            condiciones.append(NSPredicate(format: "fecha >= %@", desde as NSDate))
        }
        let pedido: NSFetchRequest<Venta> = Venta.fetchRequest()
        pedido.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: condiciones)
        let lista = (try? contexto.fetch(pedido)) ?? []
        return (CalculoVenta.redondear(lista.reduce(0) { $0 + $1.total }), lista.count)
    }

    private static func textoCantidad(_ cantidad: Int) -> String {
        cantidad == 1 ? "1 venta" : "\(cantidad) ventas"
    }

    private func tieneVentas() -> Bool {
        let pedido: NSFetchRequest<Venta> = Venta.fetchRequest()
        pedido.predicate = predicadoVendedor()
        return ((try? contexto.count(for: pedido)) ?? 0) > 0
    }

    @objc private func cambioPeriodo() {
        recargar()
    }

    // MARK: - Vistas

    private func tarjeta(_ titulo: String, _ valor: UILabel, _ cantidad: UILabel) -> UIView {
        let etiqueta = UILabel()
        etiqueta.text = titulo
        etiqueta.font = .preferredFont(forTextStyle: .subheadline)
        etiqueta.textColor = .secondaryLabel

        valor.font = .monospacedDigitSystemFont(ofSize: 22, weight: .bold)
        valor.adjustsFontSizeToFitWidth = true
        valor.minimumScaleFactor = 0.6

        cantidad.font = .preferredFont(forTextStyle: .footnote)
        cantidad.textColor = .secondaryLabel

        let pila = UIStackView(arrangedSubviews: [etiqueta, valor, cantidad])
        pila.axis = .vertical
        pila.spacing = 4
        pila.isLayoutMarginsRelativeArrangement = true
        pila.directionalLayoutMargins = .init(top: 12, leading: 14, bottom: 12, trailing: 14)
        pila.backgroundColor = .secondarySystemGroupedBackground
        pila.layer.cornerRadius = 12
        return pila
    }
}

// MARK: - Tabla

extension MisVentasViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ventas.count
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        "Solo aparecen las ventas de este vendedor."
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: celdaId, for: indexPath)
        let venta = ventas[indexPath.row]
        let anulada = venta.anulada

        let fecha = venta.fecha.map { formatoFecha.string(from: $0) } ?? "-"
        let detalle = "\(fecha) · \(venta.producto?.nombre ?? "-") × \(venta.cantidad)"

        var contenido = UIListContentConfiguration.subtitleCell()
        contenido.image = anulada
            ? UI.cuadroIcono("xmark", fondo: .systemRed.withAlphaComponent(0.15), color: .systemRed)
            : UI.cuadroIcono("checkmark", fondo: .systemGreen)
        contenido.imageProperties.maximumSize = CGSize(width: 42, height: 42)
        contenido.imageToTextPadding = 12
        contenido.text = venta.cliente?.nombre ?? "-"
        contenido.textProperties.font = .systemFont(ofSize: 16, weight: .semibold)
        contenido.textProperties.color = anulada ? .secondaryLabel : .label
        contenido.secondaryText = detalle
        contenido.secondaryTextProperties.color = .secondaryLabel
        contenido.textToSecondaryTextVerticalPadding = 3
        celda.contentConfiguration = contenido

        let labelTotal = UILabel()
        labelTotal.attributedText = Self.texto(UI.soles(venta.total), tachado: anulada,
                                               fuente: .monospacedDigitSystemFont(ofSize: 15, weight: .semibold),
                                               color: anulada ? .secondaryLabel : .label)
        var lateral: [UIView] = [labelTotal]
        if anulada {
            lateral.append(UI.pastilla("Anulada", color: .systemRed))
        }
        celda.accessoryView = UI.lateral(lateral)
        celda.selectionStyle = .none
        return celda
    }

    private static func texto(_ texto: String, tachado: Bool, fuente: UIFont, color: UIColor) -> NSAttributedString {
        var atributos: [NSAttributedString.Key: Any] = [.font: fuente, .foregroundColor: color]
        if tachado {
            atributos[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        return NSAttributedString(string: texto, attributes: atributos)
    }
}

// MARK: - Búsqueda

extension MisVentasViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        textoBusqueda = (searchController.searchBar.text ?? "").trimmingCharacters(in: .whitespaces)
        recargar()
    }
}
