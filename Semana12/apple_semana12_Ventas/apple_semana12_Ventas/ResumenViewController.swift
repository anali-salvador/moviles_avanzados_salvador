import UIKit
import CoreData

/// Pantalla A9: resumen del Supervisor. Solo cuenta ventas no anuladas.
class ResumenViewController: UIViewController {

    private let scroll = UIScrollView()
    private let pila = UIStackView()
    private let calendario = Calendar.current

    private var contexto: NSManagedObjectContext { UI.contexto }

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Resumen"
        view.backgroundColor = .systemGroupedBackground

        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        pila.axis = .vertical
        pila.spacing = 12
        pila.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(pila)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pila.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 12),
            pila.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            pila.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 16),
            pila.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recargar()
    }

    /// Vuelve a calcular todo y redibuja las secciones.
    private func recargar() {
        pila.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let ahora = Date()
        let inicioHoy = calendario.startOfDay(for: ahora)
        let inicioManana = calendario.date(byAdding: .day, value: 1, to: inicioHoy)!
        let inicioAyer = calendario.date(byAdding: .day, value: -1, to: inicioHoy)!
        let mes = calendario.dateInterval(of: .month, for: ahora)!
        let mesAnterior = calendario.dateInterval(of: .month, for: calendario.date(byAdding: .month, value: -1, to: mes.start)!)!

        // Saludo
        let usuario = Sesion.shared.usuarioActual
        let saludo = UILabel()
        saludo.text = "Hola, \(usuario?.nombre ?? "-") · \(usuario?.rol ?? "-")"
        saludo.font = .preferredFont(forTextStyle: .title2).withSize(24)
        saludo.numberOfLines = 0
        pila.addArrangedSubview(saludo)
        pila.setCustomSpacing(16, after: saludo)

        // Indicadores
        let hoy = totalVendido(desde: inicioHoy, hasta: inicioManana)
        let ayer = totalVendido(desde: inicioAyer, hasta: inicioHoy)
        let delMes = totalVendido(desde: mes.start, hasta: mes.end)
        let delMesAnterior = totalVendido(desde: mesAnterior.start, hasta: mesAnterior.end)

        let indicadores = UIStackView(arrangedSubviews: [
            tarjetaIndicador("Ventas de hoy", hoy, anterior: ayer, contra: "vs. ayer"),
            tarjetaIndicador("Ventas del mes", delMes, anterior: delMesAnterior, contra: "vs. mes anterior")
        ])
        indicadores.spacing = 12
        indicadores.distribution = .fillEqually
        indicadores.alignment = .fill
        pila.addArrangedSubview(indicadores)

        // Gráfico de los últimos 7 días
        pila.addArrangedSubview(titulo("Últimos 7 días"))
        pila.addArrangedSubview(tarjeta(graficoSemana(inicioHoy: inicioHoy)))

        // Ranking de vendedores del mes
        pila.addArrangedSubview(titulo("Ranking de vendedores del mes"))
        pila.addArrangedSubview(tarjeta(rankingVendedores(desde: mes.start, hasta: mes.end)))

        // Stock bajo
        pila.addArrangedSubview(titulo("Productos con stock bajo"))
        pila.addArrangedSubview(tarjeta(stockBajo()))
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

    private func totalVendido(desde: Date, hasta: Date) -> Double {
        CalculoVenta.redondear(ventas(desde: desde, hasta: hasta).reduce(0) { $0 + $1.total })
    }

    // MARK: - Indicadores

    private func tarjetaIndicador(_ nombre: String, _ valor: Double, anterior: Double, contra: String) -> UIView {
        let etiqueta = UILabel()
        etiqueta.text = nombre
        etiqueta.font = .preferredFont(forTextStyle: .subheadline)
        etiqueta.textColor = .secondaryLabel

        let monto = UILabel()
        monto.text = UI.soles(valor)
        monto.font = .monospacedDigitSystemFont(ofSize: 22, weight: .bold)
        monto.adjustsFontSizeToFitWidth = true
        monto.minimumScaleFactor = 0.5

        let comparacion = UILabel()
        comparacion.font = .preferredFont(forTextStyle: .footnote)
        comparacion.numberOfLines = 0
        if anterior == 0 {
            comparacion.text = "Sin datos previos"
            comparacion.textColor = .secondaryLabel
        } else {
            let cambio = (valor - anterior) / anterior * 100
            let porcentaje = String(format: "%.1f%%", abs(cambio))
            if cambio > 0 {
                comparacion.text = "▲ \(porcentaje) \(contra)"
                comparacion.textColor = .systemGreen
            } else if cambio < 0 {
                comparacion.text = "▼ \(porcentaje) \(contra)"
                comparacion.textColor = .systemRed
            } else {
                comparacion.text = "= 0.0% \(contra)"
                comparacion.textColor = .secondaryLabel
            }
        }

        let contenido = UIStackView(arrangedSubviews: [etiqueta, monto, comparacion])
        contenido.axis = .vertical
        contenido.spacing = 4
        return tarjeta(contenido)
    }

    // MARK: - Gráfico de barras

    private static let letrasDia = [1: "D", 2: "L", 3: "M", 4: "X", 5: "J", 6: "V", 7: "S"]

    private func graficoSemana(inicioHoy: Date) -> UIView {
        // Hoy y los 6 días anteriores, del más antiguo al más reciente.
        let dias: [(letra: String, total: Double, esHoy: Bool)] = (0..<7).reversed().map { atras in
            let inicio = calendario.date(byAdding: .day, value: -atras, to: inicioHoy)!
            let fin = calendario.date(byAdding: .day, value: 1, to: inicio)!
            let letra = Self.letrasDia[calendario.component(.weekday, from: inicio)] ?? "?"
            return (letra, totalVendido(desde: inicio, hasta: fin), atras == 0)
        }
        let maximo = dias.map(\.total).max() ?? 0

        let columnas = UIStackView()
        columnas.axis = .horizontal
        columnas.distribution = .fillEqually
        columnas.spacing = 6

        for dia in dias {
            let valor = UILabel()
            valor.text = dia.total == 0 ? "S/ 0" : UI.soles(dia.total)
            valor.font = .monospacedDigitSystemFont(ofSize: 10, weight: .medium)
            valor.textColor = .secondaryLabel
            valor.textAlignment = .center
            valor.adjustsFontSizeToFitWidth = true
            valor.minimumScaleFactor = 0.5

            // Área fija donde la barra crece desde abajo.
            let area = UIView()
            area.heightAnchor.constraint(equalToConstant: 120).isActive = true

            let barra = UIView()
            barra.backgroundColor = dia.esHoy ? .systemBlue : .systemBlue.withAlphaComponent(0.45)
            barra.layer.cornerRadius = 4
            barra.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            barra.translatesAutoresizingMaskIntoConstraints = false
            area.addSubview(barra)

            // Los días sin ventas muestran una barra mínima.
            let proporcion = maximo > 0 ? max(dia.total / maximo, 0.03) : 0.03
            NSLayoutConstraint.activate([
                barra.bottomAnchor.constraint(equalTo: area.bottomAnchor),
                barra.centerXAnchor.constraint(equalTo: area.centerXAnchor),
                barra.widthAnchor.constraint(equalTo: area.widthAnchor, multiplier: 0.7),
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
        let ranking = totales.values.sorted {
            $0.total != $1.total ? $0.total > $1.total
                                 : $0.nombre.localizedCaseInsensitiveCompare($1.nombre) == .orderedAscending
        }

        guard !ranking.isEmpty else { return textoVacio("Sin ventas este mes") }

        let lista = UIStackView()
        lista.axis = .vertical
        lista.spacing = 10
        for (indice, item) in ranking.enumerated() {
            let posicion = UILabel()
            posicion.text = "\(indice + 1)"
            posicion.font = .monospacedDigitSystemFont(ofSize: 15, weight: .bold)
            posicion.textColor = indice == 0 ? .systemBlue : .secondaryLabel
            posicion.widthAnchor.constraint(equalToConstant: 24).isActive = true

            let nombre = UILabel()
            nombre.text = item.nombre
            nombre.font = .preferredFont(forTextStyle: .body)

            let total = UILabel()
            total.text = UI.soles(CalculoVenta.redondear(item.total))
            total.font = .monospacedDigitSystemFont(ofSize: 15, weight: .medium)
            total.setContentHuggingPriority(.required, for: .horizontal)
            total.setContentCompressionResistancePriority(.required, for: .horizontal)

            let fila = UIStackView(arrangedSubviews: [posicion, nombre, total])
            fila.spacing = 8
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
        lista.spacing = 10
        for producto in productos {
            let nombre = UILabel()
            nombre.text = producto.nombre ?? "-"
            nombre.font = .preferredFont(forTextStyle: .body)

            let stock = UILabel()
            stock.text = "Stock: \(producto.stock)"
            stock.font = .monospacedDigitSystemFont(ofSize: 15, weight: .semibold)
            stock.textColor = .systemRed
            stock.setContentHuggingPriority(.required, for: .horizontal)
            stock.setContentCompressionResistancePriority(.required, for: .horizontal)

            lista.addArrangedSubview(UIStackView(arrangedSubviews: [nombre, stock]))
        }
        return lista
    }

    // MARK: - Ayudas de vista

    private func titulo(_ texto: String) -> UILabel {
        let label = UILabel()
        label.text = texto
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }

    private func textoVacio(_ texto: String) -> UILabel {
        let label = UILabel()
        label.text = texto
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }

    /// Envuelve una vista en una tarjeta con fondo y bordes redondeados.
    private func tarjeta(_ contenido: UIView) -> UIView {
        let fondo = UIView()
        fondo.backgroundColor = .secondarySystemGroupedBackground
        fondo.layer.cornerRadius = 12
        contenido.translatesAutoresizingMaskIntoConstraints = false
        fondo.addSubview(contenido)
        NSLayoutConstraint.activate([
            contenido.topAnchor.constraint(equalTo: fondo.topAnchor, constant: 14),
            contenido.bottomAnchor.constraint(equalTo: fondo.bottomAnchor, constant: -14),
            contenido.leadingAnchor.constraint(equalTo: fondo.leadingAnchor, constant: 14),
            contenido.trailingAnchor.constraint(equalTo: fondo.trailingAnchor, constant: -14)
        ])
        return fondo
    }
}
