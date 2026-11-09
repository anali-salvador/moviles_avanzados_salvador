import UIKit
import CoreData

/// Pantalla A9: resumen del Supervisor. Solo cuenta ventas no anuladas.
class ResumenViewController: UIViewController {

    private let scroll = UIScrollView()
    private let pila = UIStackView()
    private let calendario = Calendar.current

    private let formatoFecha: DateFormatter = {
        let formato = DateFormatter()
        formato.locale = Locale(identifier: "es_PE")
        formato.dateFormat = "EEEE d 'de' MMMM"
        return formato
    }()

    /// Montos compactos para las barras: hasta 2 decimales, sin ceros de sobra.
    private let formatoCompacto: NumberFormatter = {
        let formato = NumberFormatter()
        formato.locale = Locale(identifier: "en_US_POSIX")
        formato.minimumFractionDigits = 0
        formato.maximumFractionDigits = 2
        return formato
    }()

    private var contexto: NSManagedObjectContext { UI.contexto }

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground

        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        pila.axis = .vertical
        pila.spacing = 14
        pila.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(pila)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pila.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 8),
            pila.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            pila.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 16),
            pila.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // La cabecera propia reemplaza al título de la barra.
        navigationController?.setNavigationBarHidden(true, animated: animated)
        recargar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    /// Vuelve a calcular todo y redibuja las secciones.
    private func recargar() {
        pila.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let ahora = Date()
        let inicioHoy = calendario.startOfDay(for: ahora)
        let inicioManana = calendario.date(byAdding: .day, value: 1, to: inicioHoy)!
        let inicioAyer = calendario.date(byAdding: .day, value: -1, to: inicioHoy)!
        let mes = calendario.dateInterval(of: .month, for: ahora)!

        pila.addArrangedSubview(cabecera(fecha: ahora))

        let hoy = suma(\.total, desde: inicioHoy, hasta: inicioManana)
        let ayer = suma(\.total, desde: inicioAyer, hasta: inicioHoy)
        let igvMes = suma(\.igv, desde: mes.start, hasta: mes.end)

        let indicadores = UIStackView(arrangedSubviews: [
            tarjetaIndicador("Vendido hoy", UI.soles(hoy), comparacion: comparacion(hoy, contra: ayer)),
            tarjetaIndicador("IGV del mes", UI.soles(igvMes), comparacion: nil)
        ])
        indicadores.spacing = 12
        indicadores.distribution = .fillEqually
        indicadores.alignment = .fill
        pila.addArrangedSubview(indicadores)

        pila.addArrangedSubview(tarjeta("Ventas de los últimos 7 días (S/)", graficoSemana(inicioHoy: inicioHoy)))
        pila.addArrangedSubview(tarjeta("Ranking de vendedores (mes)", rankingVendedores(desde: mes.start, hasta: mes.end)))
        pila.addArrangedSubview(tarjeta("Stock bajo (≤ 5)", stockBajo()))
    }

    // MARK: - Consultas

    /// Ventas no anuladas en [desde, hasta).
    private func ventas(desde: Date, hasta: Date) -> [Venta] {
        let pedido: NSFetchRequest<Venta> = Venta.fetchRequest()
        pedido.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "anulada == NO"),
            NSPredicate(format: "fecha >= %@ AND fecha < %@", desde as NSDate, hasta as NSDate)
        ])
        return (try? contexto.fetch(pedido)) ?? []
    }

    /// Suma un campo (total o igv) de las ventas no anuladas del rango, redondeada a 2 decimales.
    private func suma(_ campo: KeyPath<Venta, Double>, desde: Date, hasta: Date) -> Double {
        CalculoVenta.redondear(ventas(desde: desde, hasta: hasta).reduce(0) { $0 + $1[keyPath: campo] })
    }

    // MARK: - Cabecera

    private func cabecera(fecha: Date) -> UIView {
        let textoFecha = formatoFecha.string(from: fecha)
        let labelFecha = UILabel()
        labelFecha.text = textoFecha.prefix(1).uppercased() + textoFecha.dropFirst()
        labelFecha.font = .preferredFont(forTextStyle: .subheadline)
        labelFecha.textColor = .secondaryLabel

        let usuario = Sesion.shared.usuarioActual
        let primerNombre = usuario?.nombre?.split(separator: " ").first.map(String.init) ?? "-"
        let labelHola = UILabel()
        labelHola.text = "Hola, \(primerNombre)"
        labelHola.font = .systemFont(ofSize: 30, weight: .bold)
        labelHola.adjustsFontSizeToFitWidth = true
        labelHola.minimumScaleFactor = 0.6

        let textos = UIStackView(arrangedSubviews: [labelFecha, labelHola])
        textos.axis = .vertical
        textos.spacing = 2

        let rol = pastilla(usuario?.rol ?? "-", color: .systemPurple, fuente: .systemFont(ofSize: 14, weight: .semibold))
        rol.setContentHuggingPriority(.required, for: .horizontal)
        rol.setContentCompressionResistancePriority(.required, for: .horizontal)

        let fila = UIStackView(arrangedSubviews: [textos, rol])
        fila.alignment = .center
        fila.spacing = 12
        return fila
    }

    // MARK: - Indicadores

    private func comparacion(_ valor: Double, contra anterior: Double) -> (String, UIColor) {
        guard anterior != 0 else { return ("Sin datos previos", .secondaryLabel) }
        let cambio = (valor - anterior) / anterior * 100
        let porcentaje = String(format: "%.0f%%", abs(cambio))
        if porcentaje == "0%" { return ("= 0% vs ayer", .secondaryLabel) }
        return cambio > 0 ? ("▲ \(porcentaje) vs ayer", .systemGreen)
                          : ("▼ \(porcentaje) vs ayer", .systemRed)
    }

    private func tarjetaIndicador(_ nombre: String, _ valor: String, comparacion: (String, UIColor)?) -> UIView {
        let etiqueta = UILabel()
        etiqueta.text = nombre
        etiqueta.font = .preferredFont(forTextStyle: .footnote)
        etiqueta.textColor = .secondaryLabel

        let monto = UILabel()
        monto.text = valor
        monto.font = .monospacedDigitSystemFont(ofSize: 24, weight: .bold)
        monto.adjustsFontSizeToFitWidth = true
        monto.minimumScaleFactor = 0.5

        let contenido = UIStackView(arrangedSubviews: [etiqueta, monto])
        contenido.axis = .vertical
        contenido.spacing = 4
        contenido.alignment = .leading

        if let (texto, color) = comparacion {
            let labelComparacion = UILabel()
            labelComparacion.text = texto
            labelComparacion.textColor = color
            labelComparacion.font = .systemFont(ofSize: 13, weight: .semibold)
            contenido.addArrangedSubview(labelComparacion)
        }
        // Empuja el contenido hacia arriba si la otra tarjeta es más alta.
        contenido.addArrangedSubview(UIView())
        return tarjeta(nil, contenido)
    }

    // MARK: - Gráfico de barras

    private static let letrasDia = [1: "D", 2: "L", 3: "M", 4: "X", 5: "J", 6: "V", 7: "S"]

    private func graficoSemana(inicioHoy: Date) -> UIView {
        // Hoy y los 6 días anteriores, del más antiguo al más reciente.
        let dias: [(letra: String, total: Double, esHoy: Bool)] = (0..<7).reversed().map { atras in
            let inicio = calendario.date(byAdding: .day, value: -atras, to: inicioHoy)!
            let fin = calendario.date(byAdding: .day, value: 1, to: inicio)!
            let letra = Self.letrasDia[calendario.component(.weekday, from: inicio)] ?? "?"
            return (letra, suma(\.total, desde: inicio, hasta: fin), atras == 0)
        }
        let maximo = dias.map(\.total).max() ?? 0

        let columnas = UIStackView()
        columnas.axis = .horizontal
        columnas.distribution = .fillEqually
        columnas.spacing = 8

        for dia in dias {
            let valor = UILabel()
            valor.text = dia.total == 0 ? "0" : (formatoCompacto.string(from: dia.total as NSNumber) ?? "0")
            valor.font = .monospacedDigitSystemFont(ofSize: 10, weight: .medium)
            valor.textColor = .secondaryLabel
            valor.textAlignment = .center
            valor.adjustsFontSizeToFitWidth = true
            valor.minimumScaleFactor = 0.5

            // Área fija donde la barra crece desde abajo.
            let area = UIView()
            area.heightAnchor.constraint(equalToConstant: 120).isActive = true

            let barra = UIView()
            barra.backgroundColor = dia.esHoy ? .systemBlue : .systemBlue.withAlphaComponent(0.18)
            barra.layer.cornerRadius = 6
            barra.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            barra.translatesAutoresizingMaskIntoConstraints = false
            area.addSubview(barra)

            // Los días sin ventas muestran una barra mínima.
            let proporcion = maximo > 0 ? max(dia.total / maximo, 0.04) : 0.04
            NSLayoutConstraint.activate([
                barra.bottomAnchor.constraint(equalTo: area.bottomAnchor),
                barra.leadingAnchor.constraint(equalTo: area.leadingAnchor),
                barra.trailingAnchor.constraint(equalTo: area.trailingAnchor),
                barra.heightAnchor.constraint(equalTo: area.heightAnchor, multiplier: CGFloat(proporcion))
            ])

            let letra = UILabel()
            letra.text = dia.letra
            letra.font = .systemFont(ofSize: 13, weight: dia.esHoy ? .bold : .regular)
            letra.textColor = dia.esHoy ? .label : .secondaryLabel
            letra.textAlignment = .center

            let columna = UIStackView(arrangedSubviews: [valor, area, letra])
            columna.axis = .vertical
            columna.spacing = 4
            columnas.addArrangedSubview(columna)
        }
        return columnas
    }

    // MARK: - Ranking

    private func rankingVendedores(desde: Date, hasta: Date) -> UIView {
        var totales: [NSManagedObjectID: (nombre: String, total: Double)] = [:]
        for venta in ventas(desde: desde, hasta: hasta) {
            guard let vendedor = venta.vendedor else { continue }
            let nombre = vendedor.nombre ?? vendedor.usuario ?? "-"
            totales[vendedor.objectID, default: (nombre, 0)].total += venta.total
        }
        typealias Item = (nombre: String, total: Double)
        let redondeados: [Item] = totales.values.map { item -> Item in
            (nombre: item.nombre, total: CalculoVenta.redondear(item.total))
        }
        let ranking: [Item] = redondeados.sorted { (a: Item, b: Item) -> Bool in
            if a.total != b.total { return a.total > b.total }
            return a.nombre.localizedCaseInsensitiveCompare(b.nombre) == .orderedAscending
        }

        guard let primero = ranking.first, primero.total > 0 else { return textoVacio("Sin ventas este mes") }

        let lista = UIStackView()
        lista.axis = .vertical
        lista.spacing = 14
        for item in ranking {
            let linea = NSMutableAttributedString(
                string: item.nombre,
                attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .bold), .foregroundColor: UIColor.label])
            linea.append(NSAttributedString(
                string: " · \(UI.soles(item.total))",
                attributes: [.font: UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .regular),
                             .foregroundColor: UIColor.secondaryLabel]))
            let label = UILabel()
            label.attributedText = linea

            let barra = UIProgressView(progressViewStyle: .default)
            barra.progressTintColor = .systemBlue
            barra.trackTintColor = .systemBlue.withAlphaComponent(0.12)
            barra.progress = Float(item.total / primero.total)
            barra.heightAnchor.constraint(equalToConstant: 8).isActive = true
            barra.layer.cornerRadius = 4
            barra.clipsToBounds = true
            barra.subviews.forEach { $0.layer.cornerRadius = 4; $0.clipsToBounds = true }

            let fila = UIStackView(arrangedSubviews: [label, barra])
            fila.axis = .vertical
            fila.spacing = 6
            lista.addArrangedSubview(fila)
        }
        return lista
    }

    // MARK: - Stock bajo

    private func stockBajo() -> UIView {
        let pedido: NSFetchRequest<Producto> = Producto.fetchRequest()
        pedido.predicate = NSPredicate(format: "stock <= 5")
        pedido.sortDescriptors = [
            NSSortDescriptor(key: "stock", ascending: true),
            NSSortDescriptor(key: "nombre", ascending: true,
                             selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        ]
        let productos = (try? contexto.fetch(pedido)) ?? []

        guard !productos.isEmpty else { return textoVacio("Sin productos con stock bajo") }

        let lista = UIStackView()
        lista.axis = .vertical
        lista.spacing = 12
        for producto in productos {
            let nombre = UILabel()
            nombre.text = "\(producto.nombre ?? "-") · \(producto.stock) u."
            nombre.font = .preferredFont(forTextStyle: .body)
            nombre.numberOfLines = 0

            let reponer = pastilla("Reponer", color: .systemRed, fuente: .systemFont(ofSize: 12, weight: .semibold))
            reponer.setContentHuggingPriority(.required, for: .horizontal)
            reponer.setContentCompressionResistancePriority(.required, for: .horizontal)

            let fila = UIStackView(arrangedSubviews: [nombre, reponer])
            fila.alignment = .center
            fila.spacing = 8
            lista.addArrangedSubview(fila)
        }
        return lista
    }

    // MARK: - Ayudas de vista

    private func textoVacio(_ texto: String) -> UILabel {
        let label = UILabel()
        label.text = texto
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }

    /// Etiqueta con fondo de color, texto blanco y bordes de cápsula.
    private func pastilla(_ texto: String, color: UIColor, fuente: UIFont) -> UIView {
        let label = UILabel()
        label.text = texto
        label.font = fuente
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        let fondo = UIView()
        fondo.backgroundColor = color
        fondo.layer.cornerRadius = (fuente.lineHeight + 8) / 2
        fondo.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: fondo.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: fondo.bottomAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: fondo.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: fondo.trailingAnchor, constant: -12)
        ])
        return fondo
    }

    /// Tarjeta blanca con bordes redondeados y título opcional en gris pequeño.
    private func tarjeta(_ titulo: String?, _ contenido: UIView) -> UIView {
        var vistas: [UIView] = []
        if let titulo {
            let label = UILabel()
            label.text = titulo
            label.font = .systemFont(ofSize: 13, weight: .semibold)
            label.textColor = .secondaryLabel
            vistas.append(label)
        }
        vistas.append(contenido)

        let interior = UIStackView(arrangedSubviews: vistas)
        interior.axis = .vertical
        interior.spacing = 12
        interior.translatesAutoresizingMaskIntoConstraints = false

        let fondo = UIView()
        fondo.backgroundColor = .secondarySystemGroupedBackground
        fondo.layer.cornerRadius = 16
        fondo.addSubview(interior)
        NSLayoutConstraint.activate([
            interior.topAnchor.constraint(equalTo: fondo.topAnchor, constant: 16),
            interior.bottomAnchor.constraint(equalTo: fondo.bottomAnchor, constant: -16),
            interior.leadingAnchor.constraint(equalTo: fondo.leadingAnchor, constant: 16),
            interior.trailingAnchor.constraint(equalTo: fondo.trailingAnchor, constant: -16)
        ])
        return fondo
    }
}
