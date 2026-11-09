import UIKit
import CoreData

/// Pantalla A7: todas las ventas del equipo (Supervisor).
class VentasEquipoViewController: UIViewController {

    private let celdaId = "VentaEquipoCelda"
    private var ventas: [Venta] = []
    private var vendedores: [Usuario] = []
    private var vendedorSeleccionado: Usuario?   // nil = "Todos"

    private let pilaChips = UIStackView()
    private let tabla = UITableView(frame: .zero, style: .insetGrouped)
    private let labelVacio = UILabel()

    private let formatoFecha: DateFormatter = {
        let formato = DateFormatter()
        formato.dateStyle = .short
        formato.timeStyle = .short
        return formato
    }()

    private var contexto: NSManagedObjectContext { UI.contexto }

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ventas"
        view.backgroundColor = .systemGroupedBackground

        let scrollChips = UIScrollView()
        scrollChips.showsHorizontalScrollIndicator = false
        scrollChips.translatesAutoresizingMaskIntoConstraints = false
        pilaChips.axis = .horizontal
        pilaChips.spacing = 8
        pilaChips.translatesAutoresizingMaskIntoConstraints = false
        scrollChips.addSubview(pilaChips)

        let nota = UILabel()
        nota.text = "Cada venta guarda quién la registró (relación venta a vendedor)"
        nota.font = .preferredFont(forTextStyle: .caption1)
        nota.textColor = .secondaryLabel
        nota.numberOfLines = 0
        nota.translatesAutoresizingMaskIntoConstraints = false

        tabla.translatesAutoresizingMaskIntoConstraints = false
        tabla.dataSource = self
        tabla.allowsSelection = false
        tabla.register(UITableViewCell.self, forCellReuseIdentifier: celdaId)

        view.addSubview(scrollChips)
        view.addSubview(nota)
        view.addSubview(tabla)
        let guia = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollChips.topAnchor.constraint(equalTo: guia.topAnchor, constant: 8),
            scrollChips.leadingAnchor.constraint(equalTo: guia.leadingAnchor),
            scrollChips.trailingAnchor.constraint(equalTo: guia.trailingAnchor),
            scrollChips.heightAnchor.constraint(equalToConstant: 40),
            pilaChips.leadingAnchor.constraint(equalTo: scrollChips.contentLayoutGuide.leadingAnchor, constant: 20),
            pilaChips.trailingAnchor.constraint(equalTo: scrollChips.contentLayoutGuide.trailingAnchor, constant: -20),
            pilaChips.topAnchor.constraint(equalTo: scrollChips.contentLayoutGuide.topAnchor),
            pilaChips.bottomAnchor.constraint(equalTo: scrollChips.contentLayoutGuide.bottomAnchor),
            pilaChips.heightAnchor.constraint(equalTo: scrollChips.frameLayoutGuide.heightAnchor),

            nota.topAnchor.constraint(equalTo: scrollChips.bottomAnchor, constant: 8),
            nota.leadingAnchor.constraint(equalTo: guia.leadingAnchor, constant: 20),
            nota.trailingAnchor.constraint(equalTo: guia.trailingAnchor, constant: -20),

            tabla.topAnchor.constraint(equalTo: nota.bottomAnchor, constant: 4),
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

    private func recargar() {
        cargarVendedores()

        let pedido: NSFetchRequest<Venta> = Venta.fetchRequest()
        if let vendedor = vendedorSeleccionado {
            pedido.predicate = NSPredicate(format: "vendedor == %@", vendedor)
        }
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

    // MARK: - Chips

    private func dibujarChips() {
        pilaChips.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let nombres = ["Todos"] + vendedores.map { $0.nombre ?? $0.usuario ?? "-" }
        for (indice, nombre) in nombres.enumerated() {
            let chip = UIButton(configuration: .gray())
            chip.configuration?.title = nombre
            chip.configuration?.cornerStyle = .capsule
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
}

// MARK: - Tabla

extension VentasEquipoViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ventas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: celdaId, for: indexPath)
        let venta = ventas[indexPath.row]
        let anulada = venta.anulada
        let cuerpo = UIFont.preferredFont(forTextStyle: .subheadline)

        let fecha = venta.fecha.map { formatoFecha.string(from: $0) } ?? "-"
        let vendedor = venta.vendedor?.nombre ?? venta.vendedor?.usuario ?? "-"

        var contenido = UIListContentConfiguration.subtitleCell()
        contenido.attributedText = Self.texto(venta.cliente?.nombre ?? "-", tachado: anulada,
                                              fuente: .preferredFont(forTextStyle: .body),
                                              color: anulada ? .secondaryLabel : .label)

        let detalle = NSMutableAttributedString()
        detalle.append(Self.texto("Vendedor: \(vendedor)\n", tachado: anulada, fuente: cuerpo, color: .secondaryLabel))
        detalle.append(Self.texto("\(venta.producto?.nombre ?? "-")  ·  x\(venta.cantidad)  ·  \(fecha)",
                                  tachado: anulada, fuente: cuerpo, color: .secondaryLabel))
        if anulada {
            let motivo = venta.motivoAnulacion ?? "-"
            detalle.append(Self.texto("\nMotivo: \(motivo)", tachado: false,
                                      fuente: .preferredFont(forTextStyle: .footnote), color: .systemGray))
        }
        contenido.secondaryAttributedText = detalle
        contenido.textToSecondaryTextVerticalPadding = 4
        celda.contentConfiguration = contenido

        let labelTotal = UILabel()
        labelTotal.attributedText = Self.texto(UI.soles(venta.total), tachado: anulada,
                                               fuente: .monospacedDigitSystemFont(ofSize: 15, weight: .medium),
                                               color: anulada ? .secondaryLabel : .label)
        let lateral = UIStackView(arrangedSubviews: [labelTotal])
        lateral.axis = .vertical
        lateral.alignment = .trailing
        lateral.spacing = 2
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

    static func texto(_ texto: String, tachado: Bool, fuente: UIFont, color: UIColor) -> NSAttributedString {
        var atributos: [NSAttributedString.Key: Any] = [.font: fuente, .foregroundColor: color]
        if tachado {
            atributos[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        return NSAttributedString(string: texto, attributes: atributos)
    }
}
