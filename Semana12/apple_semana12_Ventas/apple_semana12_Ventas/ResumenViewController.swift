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
        view.backgroundColor = Tema.fondo

        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        pila.axis = .vertical
        pila.spacing = 16
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
            tarjetaIndicador("Vendido hoy", "banknote.fill", UI.soles(hoy), comparacion: comparacion(hoy, contra: ayer)),
            tarjetaIndicador("IGV del mes", "percent", UI.soles(igvMes), comparacion: nil)
        ])
        indicadores.spacing = 12
        indicadores.distribution = .fillEqually
        indicadores.alignment = .fill
        pila.addArrangedSubview(indicadores)

        pila.addArrangedSubview(tarjeta("Ventas de los últimos 7 días (S/)", "chart.bar.fill",
                                        graficoSemana(inicioHoy: inicioHoy)))
        pila.addArrangedSubview(tarjeta("Ranking de vendedores (mes)", "trophy.fill",
                                        rankingVendedores(desde: mes.start, hasta: mes.end)))
        pila.addArrangedSubview(tarjeta("Stock bajo (≤ 5)", "exclamationmark.triangle.fill", stockBajo(),
                                        color: Tema.acento))
        Tema.animarEntrada(pila.arrangedSubviews, paso: 0.06)
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

    /// Cabecera con degradado teal: fecha, saludo en blanco y rol.
    private func cabecera(fecha: Date) -> UIView {
        let textoFecha = formatoFecha.string(from: fecha)
        let labelFecha = UILabel()
        labelFecha.text = textoFecha.prefix(1).uppercased() + textoFecha.dropFirst()
        labelFecha.font = Tema.fuente(14, .semibold)
        labelFecha.textColor = UIColor.white.withAlphaComponent(0.8)

        let usuario = Sesion.shared.usuarioActual
        let primerNombre = usuario?.nombre?.split(separator: " ").first.map(String.init) ?? "-"
        let labelHola = UILabel()
        labelHola.text = "Hola, \(primerNombre)"
        labelHola.font = Tema.fuente(32, .heavy)
        labelHola.textColor = .white
        labelHola.adjustsFontSizeToFitWidth = true
        labelHola.minimumScaleFactor = 0.6

        let rol = UILabel()
        rol.text = "  \(usuario?.rol ?? "-")  "
        rol.font = Tema.fuente(13, .bold)
        rol.textColor = .white
        rol.backgroundColor = UIColor.white.withAlphaComponent(0.22)
        rol.layer.cornerRadius = 13
        rol.clipsToBounds = true
        rol.heightAnchor.constraint(equalToConstant: 26).isActive = true

        let filaRol = UIStackView(arrangedSubviews: [rol, UIView()])

        let textos = UIStackView(arrangedSubviews: [labelFecha, labelHola, filaRol])
        textos.axis = .vertical
        textos.spacing = 4
        textos.setCustomSpacing(10, after: labelHola)

        let icono = UIImageView(image: UIImage(systemName: "sparkles"))
        icono.tintColor = UIColor.white.withAlphaComponent(0.9)
        icono.preferredSymbolConfiguration = .init(pointSize: 34, weight: .semibold)
        icono.setContentHuggingPriority(.required, for: .horizontal)

        let fila = UIStackView(arrangedSubviews: [textos, icono])
        fila.alignment = .center
        fila.spacing = 12
        return Tema.tarjetaDegradado(fila, relleno: 22)
    }

    // MARK: - Indicadores

    private func comparacion(_ valor: Double, contra anterior: Double) -> (String, UIColor) {
        guard anterior != 0 else { return ("Sin datos previos", Tema.textoSecundario) }
        let cambio = (valor - anterior) / anterior * 100
        let porcentaje = String(format: "%.0f%%", abs(cambio))
        if porcentaje == "0%" { return ("= 0% vs ayer", Tema.textoSecundario) }
        return cambio > 0 ? ("▲ \(porcentaje) vs ayer", Tema.exito)
                          : ("▼ \(porcentaje) vs ayer", Tema.error)
    }

    private func tarjetaIndicador(_ nombre: String, _ simbolo: String, _ valor: String,
                                  comparacion: (String, UIColor)?) -> UIView {
        let etiqueta = Tema.etiqueta(nombre)

        let monto = UILabel()
        monto.text = valor
        monto.font = Tema.numero(24, .heavy)
        monto.adjustsFontSizeToFitWidth = true
        monto.minimumScaleFactor = 0.5

        let contenido = UIStackView(arrangedSubviews: [Tema.icono(simbolo, lado: 34), etiqueta, monto])
        contenido.axis = .vertical
        contenido.spacing = 6
        contenido.alignment = .leading
        contenido.setCustomSpacing(10, after: contenido.arrangedSubviews[0])

        if let (texto, color) = comparacion {
            contenido.addArrangedSubview(Tema.pildora(texto, color: color, fuente: Tema.fuente(12, .bold)))
        }
        // Empuja el contenido hacia arriba si la otra tarjeta es más alta.
        contenido.addArrangedSubview(UIView())
        return Tema.tarjeta(contenido)
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
        columnas.spacing = 10

        for dia in dias {
            let valor = UILabel()
            valor.text = dia.total == 0 ? "0" : (formatoCompacto.string(from: dia.total as NSNumber) ?? "0")
            valor.font = Tema.numero(10, dia.esHoy ? .bold : .medium)
            valor.textColor = dia.esHoy ? Tema.tono(Tema.acento) : Tema.textoSecundario
            valor.textAlignment = .center
            valor.adjustsFontSizeToFitWidth = true
            valor.minimumScaleFactor = 0.5

            // Área fija donde la barra crece desde abajo, sobre un riel suave.
            let area = UIView()
            area.backgroundColor = Tema.suave
            area.layer.cornerRadius = 8
            area.layer.cornerCurve = .continuous
            area.heightAnchor.constraint(equalToConstant: 130).isActive = true

            let colores = dia.esHoy ? Tema.degradadoCoral.reversed() : [Tema.principalClaro, Tema.principalOscuro]
            let barra = VistaDegradado(colores: Array(colores),
                                       inicio: CGPoint(x: 0.5, y: 0), fin: CGPoint(x: 0.5, y: 1))
            barra.layer.cornerRadius = 8
            barra.layer.cornerCurve = .continuous
            barra.clipsToBounds = true
            barra.translatesAutoresizingMaskIntoConstraints = false
            area.addSubview(barra)

            // Los días sin ventas muestran una barra mínima.
            let proporcion = maximo > 0 ? max(dia.total / maximo, 0.06) : 0.06
            NSLayoutConstraint.activate([
                barra.bottomAnchor.constraint(equalTo: area.bottomAnchor),
                barra.leadingAnchor.constraint(equalTo: area.leadingAnchor),
                barra.trailingAnchor.constraint(equalTo: area.trailingAnchor),
                barra.heightAnchor.constraint(equalTo: area.heightAnchor, multiplier: CGFloat(proporcion))
            ])

            let letra = UILabel()
            letra.text = dia.letra
            letra.font = Tema.fuente(13, dia.esHoy ? .heavy : .medium)
            letra.textColor = dia.esHoy ? Tema.tono(Tema.acento) : Tema.textoSecundario
            letra.textAlignment = .center

            let columna = UIStackView(arrangedSubviews: [valor, area, letra])
            columna.axis = .vertical
            columna.spacing = 6
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
        lista.spacing = 16
        for (posicion, item) in ranking.enumerated() {
            let numero = UILabel()
            numero.text = "\(posicion + 1)"
            numero.font = Tema.fuente(14, .heavy)
            numero.textAlignment = .center
            numero.textColor = posicion == 0 ? .white : Tema.principal
            numero.backgroundColor = posicion == 0 ? Tema.principal : Tema.suave
            numero.layer.cornerRadius = 15
            numero.clipsToBounds = true
            numero.widthAnchor.constraint(equalToConstant: 30).isActive = true
            numero.heightAnchor.constraint(equalToConstant: 30).isActive = true

            let nombre = UILabel()
            nombre.text = item.nombre
            nombre.font = Tema.fuente(15, .bold)

            let monto = UILabel()
            monto.text = UI.soles(item.total)
            monto.font = Tema.numero(15, .semibold)
            monto.textColor = Tema.principal
            monto.setContentHuggingPriority(.required, for: .horizontal)

            let linea = UIStackView(arrangedSubviews: [nombre, monto])
            linea.spacing = 8

            let barra = UIProgressView(progressViewStyle: .default)
            barra.progressTintColor = Tema.principal
            barra.trackTintColor = Tema.suave
            barra.progress = Float(item.total / primero.total)
            barra.heightAnchor.constraint(equalToConstant: 10).isActive = true
            barra.layer.cornerRadius = 5
            barra.clipsToBounds = true
            barra.subviews.forEach { $0.layer.cornerRadius = 5; $0.clipsToBounds = true }

            let textos = UIStackView(arrangedSubviews: [linea, barra])
            textos.axis = .vertical
            textos.spacing = 7

            let fila = UIStackView(arrangedSubviews: [numero, textos])
            fila.spacing = 12
            fila.alignment = .center
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
            nombre.text = producto.nombre ?? "-"
            nombre.font = Tema.fuente(15, .semibold)
            nombre.numberOfLines = 0

            let unidades = UILabel()
            unidades.text = "\(producto.stock) u."
            unidades.font = Tema.numero(14, .bold)
            unidades.textColor = Tema.textoSecundario
            unidades.setContentHuggingPriority(.required, for: .horizontal)

            let reponer = Tema.pildora("Reponer", color: Tema.acento)

            let fila = UIStackView(arrangedSubviews: [Tema.icono("shippingbox.fill", color: Tema.acento, lado: 32),
                                                      nombre, unidades, reponer])
            fila.alignment = .center
            fila.spacing = 10
            lista.addArrangedSubview(fila)
        }
        return lista
    }

    // MARK: - Ayudas de vista

    private func textoVacio(_ texto: String) -> UILabel {
        let label = UILabel()
        label.text = texto
        label.font = Tema.fuente(15, .medium)
        label.textColor = Tema.textoSecundario
        return label
    }

    /// Tarjeta con sombra, con un ícono y título arriba.
    private func tarjeta(_ titulo: String, _ simbolo: String, _ contenido: UIView,
                         color: UIColor = Tema.principal) -> UIView {
        let icono = UIImageView(image: UIImage(systemName: simbolo))
        icono.tintColor = color
        icono.preferredSymbolConfiguration = .init(pointSize: 14, weight: .bold)
        icono.setContentHuggingPriority(.required, for: .horizontal)

        let label = UILabel()
        label.text = titulo
        label.font = Tema.fuente(15, .bold)

        let cabecera = UIStackView(arrangedSubviews: [icono, label])
        cabecera.spacing = 8
        cabecera.alignment = .center

        let interior = UIStackView(arrangedSubviews: [cabecera, contenido])
        interior.axis = .vertical
        interior.spacing = 16
        return Tema.tarjeta(interior, relleno: 18)
    }
}
