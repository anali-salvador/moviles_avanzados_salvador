import UIKit
import CoreData

/// Pantalla A6: ventas del vendedor de la sesión (solo consulta, no puede anular).
class MisVentasViewController: UIViewController {

    private enum Periodo: Int { case todas, hoy, mes }

    private var ventas: [Venta] = []
    private var textoBusqueda = ""

    private let valorHoy = UILabel()
    private let valorMes = UILabel()
    private let cantidadHoy = UILabel()
    private let cantidadMes = UILabel()
    private let selectorPeriodo = UISegmentedControl(items: ["Todas", "Hoy", "Mes"])
    private let tabla = UITableView(frame: .zero, style: .plain)
    private let entrada = EntradaFilas()
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
        view.backgroundColor = Tema.fondo

        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por cliente"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        // Iniciales del vendedor de la sesión, solo informativas.
        navigationItem.rightBarButtonItem = Self.botonAvatar(Sesion.shared.usuarioActual?.nombre)

        let indicadores = UIStackView(arrangedSubviews: [
            tarjeta("Hoy", "sun.max.fill", valorHoy, cantidadHoy, colores: Tema.degradadoTeal),
            tarjeta("Mes", "calendar", valorMes, cantidadMes, colores: Tema.degradadoCoral)
        ])
        indicadores.spacing = 12
        indicadores.distribution = .fillEqually

        selectorPeriodo.selectedSegmentIndex = Periodo.todas.rawValue
        Tema.estilizar(selectorPeriodo)
        selectorPeriodo.addTarget(self, action: #selector(cambioPeriodo), for: .valueChanged)

        let cabecera = UIStackView(arrangedSubviews: [indicadores, selectorPeriodo])
        cabecera.axis = .vertical
        cabecera.spacing = 14
        cabecera.translatesAutoresizingMaskIntoConstraints = false

        tabla.translatesAutoresizingMaskIntoConstraints = false
        tabla.dataSource = self
        tabla.delegate = self
        tabla.allowsSelection = false
        tabla.prepararParaTarjetas()
        tabla.tableFooterView = Tema.pieTabla("Solo aparecen las ventas de este vendedor.", ancho: view.bounds.width)

        view.addSubview(cabecera)
        view.addSubview(tabla)
        let guia = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            cabecera.topAnchor.constraint(equalTo: guia.topAnchor, constant: 8),
            cabecera.leadingAnchor.constraint(equalTo: guia.leadingAnchor, constant: Tema.margen),
            cabecera.trailingAnchor.constraint(equalTo: guia.trailingAnchor, constant: -Tema.margen),
            tabla.topAnchor.constraint(equalTo: cabecera.bottomAnchor, constant: 4),
            tabla.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabla.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabla.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        labelVacio.font = Tema.fuente(16, .medium)
        labelVacio.textColor = Tema.textoSecundario
        labelVacio.textAlignment = .center
        labelVacio.numberOfLines = 0

        Tema.animarEntrada([indicadores, selectorPeriodo])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entrada.reiniciar()
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

    /// Tarjeta de resumen con degradado y texto blanco.
    private func tarjeta(_ titulo: String, _ simbolo: String, _ valor: UILabel, _ cantidad: UILabel,
                         colores: [UIColor]) -> UIView {
        let icono = UIImageView(image: UIImage(systemName: simbolo))
        icono.tintColor = .white
        icono.preferredSymbolConfiguration = .init(pointSize: 13, weight: .bold)

        let etiqueta = UILabel()
        etiqueta.text = titulo.uppercased()
        etiqueta.font = Tema.fuente(12, .bold)
        etiqueta.textColor = UIColor.white.withAlphaComponent(0.85)

        let cabecera = UIStackView(arrangedSubviews: [icono, etiqueta])
        cabecera.spacing = 6
        cabecera.alignment = .center

        valor.font = Tema.numero(24, .heavy)
        valor.textColor = .white
        valor.adjustsFontSizeToFitWidth = true
        valor.minimumScaleFactor = 0.6

        cantidad.font = Tema.fuente(13, .semibold)
        cantidad.textColor = UIColor.white.withAlphaComponent(0.85)

        let pila = UIStackView(arrangedSubviews: [cabecera, valor, cantidad])
        pila.axis = .vertical
        pila.alignment = .leading
        pila.spacing = 4
        return Tema.tarjetaDegradado(pila, colores: colores, relleno: 16)
    }

    /// Botón de barra (solo informativo) con un círculo teal y las iniciales del usuario.
    static func botonAvatar(_ nombre: String?) -> UIBarButtonItem {
        let lado: CGFloat = 34
        let imagen = UI.cuadroTexto(UI.iniciales(de: nombre), fondo: Tema.principalOscuro, lado: lado)
        let vista = UIImageView(image: imagen)
        vista.frame = CGRect(x: 0, y: 0, width: lado, height: lado)
        vista.layer.cornerRadius = lado / 2
        vista.clipsToBounds = true
        let boton = UIBarButtonItem(customView: vista)
        boton.hidesSharedBackground = true
        return boton
    }
}

// MARK: - Tabla

extension MisVentasViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ventas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: CeldaTarjeta.id, for: indexPath) as! CeldaTarjeta
        let venta = ventas[indexPath.row]
        let anulada = venta.anulada

        let fecha = venta.fecha.map { formatoFecha.string(from: $0) } ?? "-"
        let detalle = "\(fecha) · \(venta.producto?.nombre ?? "-") × \(venta.cantidad)"

        celda.franja.backgroundColor = anulada ? Tema.error : Tema.exito
        celda.icono.image = anulada
            ? UI.cuadroIcono("xmark", fondo: Tema.error.withAlphaComponent(0.15), color: Tema.error, lado: 44)
            : UI.cuadroIcono("checkmark", fondo: Tema.exito, lado: 44)
        celda.titulo.text = venta.cliente?.nombre ?? "-"
        celda.titulo.textColor = anulada ? Tema.textoSecundario : .label
        celda.subtitulo.text = detalle

        let labelTotal = UILabel()
        labelTotal.attributedText = Self.texto(UI.soles(venta.total), tachado: anulada,
                                               fuente: Tema.numero(16, .bold),
                                               color: anulada ? Tema.textoSecundario : Tema.principal)
        var lateral: [UIView] = [labelTotal]
        if anulada {
            lateral.append(UI.pastilla("Anulada", color: Tema.error))
        }
        celda.ponerLateral(lateral)
        return celda
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        entrada.aplicar(a: cell, en: indexPath)
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
