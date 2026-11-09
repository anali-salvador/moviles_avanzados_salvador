import UIKit
import CoreData

/// Pantalla A5: registrar una venta (Vendedor).
class NuevaVentaViewController: UIViewController {

    private var cliente: Cliente?
    private var producto: Producto?
    private var cantidad: Int { Int(stepper.value) }

    private let valorCliente = UILabel()
    private let valorProducto = UILabel()
    private let labelStock = UILabel()
    private let labelCantidad = UILabel()
    private let stepper = UIStepper()

    private let valorSubtotal = UILabel()
    private let etiquetaDescuento = UILabel()
    private let valorDescuento = UILabel()
    private let valorIGV = UILabel()
    private let valorTotal = UILabel()

    private var contexto: NSManagedObjectContext { UI.contexto }

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Venta"
        view.backgroundColor = .systemGroupedBackground

        stepper.minimumValue = 1
        stepper.maximumValue = 999
        stepper.value = 1
        stepper.addTarget(self, action: #selector(cambioCantidad), for: .valueChanged)

        let botonRegistrar = UI.botonPrincipal("Registrar venta")
        botonRegistrar.addTarget(self, action: #selector(registrar), for: .touchUpInside)

        let etiquetaResumen = UI.etiquetaSeccion("Resumen (calculado)")
        let datos = tarjetaDatos()
        let resumen = tarjetaResumen()

        let pila = UI.pila([tarjetaVendedor(), datos, etiquetaResumen, resumen, botonRegistrar], en: view)
        pila.spacing = 16
        pila.setCustomSpacing(24, after: datos)
        pila.setCustomSpacing(6, after: etiquetaResumen)
        pila.setCustomSpacing(24, after: resumen)

        actualizar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Clientes o productos pueden haber cambiado en otras pestañas.
        if let cliente, cliente.isDeleted || cliente.managedObjectContext == nil { self.cliente = nil }
        if let producto, producto.isDeleted || producto.managedObjectContext == nil { self.producto = nil }
        actualizar()
    }

    // MARK: - Vistas

    /// Tarjeta azul clara con las iniciales y el nombre del vendedor de la sesión.
    private func tarjetaVendedor() -> UIView {
        let usuario = Sesion.shared.usuarioActual

        let circulo = UILabel()
        circulo.text = UI.iniciales(de: usuario?.nombre)
        circulo.font = .systemFont(ofSize: 16, weight: .bold)
        circulo.textColor = .white
        circulo.textAlignment = .center
        circulo.backgroundColor = .systemBlue
        circulo.layer.cornerRadius = 22
        circulo.clipsToBounds = true
        circulo.widthAnchor.constraint(equalToConstant: 44).isActive = true
        circulo.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let nombre = UILabel()
        nombre.text = "\(usuario?.nombre ?? "-") · \(usuario?.rol ?? "Vendedor")"
        nombre.font = .systemFont(ofSize: 16, weight: .semibold)
        nombre.textColor = .systemBlue
        nombre.numberOfLines = 0

        let nota = UILabel()
        nota.text = "Sesión iniciada · la venta se registra a tu nombre"
        nota.font = .preferredFont(forTextStyle: .caption1)
        nota.textColor = .secondaryLabel
        nota.numberOfLines = 0

        let textos = UIStackView(arrangedSubviews: [nombre, nota])
        textos.axis = .vertical
        textos.spacing = 2

        let fila = UIStackView(arrangedSubviews: [circulo, textos])
        fila.spacing = 12
        fila.alignment = .center
        fila.isLayoutMarginsRelativeArrangement = true
        fila.directionalLayoutMargins = .init(top: 14, leading: 14, bottom: 14, trailing: 14)
        fila.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        fila.layer.cornerRadius = 14
        return fila
    }

    /// Lista agrupada: Cliente ›, Producto ›, Cantidad (stock N) con stepper.
    private func tarjetaDatos() -> UIView {
        for valor in [valorCliente, valorProducto] {
            valor.font = .preferredFont(forTextStyle: .body)
            valor.textAlignment = .right
            valor.lineBreakMode = .byTruncatingTail
        }

        labelStock.font = .preferredFont(forTextStyle: .subheadline)
        labelStock.textColor = .secondaryLabel
        labelCantidad.font = .monospacedDigitSystemFont(ofSize: 17, weight: .semibold)

        let filaCliente = filaElegible("Cliente", valorCliente, accion: #selector(elegirCliente))
        let filaProducto = filaElegible("Producto", valorProducto, accion: #selector(elegirProducto))

        let tituloCantidad = UILabel()
        tituloCantidad.text = "Cantidad"
        tituloCantidad.font = .preferredFont(forTextStyle: .body)
        tituloCantidad.setContentHuggingPriority(.required, for: .horizontal)
        let espacio = UIView()
        let filaCantidad = UIStackView(arrangedSubviews: [tituloCantidad, labelStock, espacio, labelCantidad, stepper])
        filaCantidad.spacing = 6
        filaCantidad.setCustomSpacing(12, after: labelCantidad)
        filaCantidad.alignment = .center

        return tarjetaLista([filaCliente, filaProducto, filaCantidad])
    }

    /// Resumen: Subtotal, Descuento, IGV 18% y Total.
    private func tarjetaResumen() -> UIView {
        let filas = [
            filaResumen("Subtotal", valorSubtotal),
            filaResumen(etiquetaDescuento, valorDescuento),
            filaResumen("IGV 18%", valorIGV),
            filaResumen("Total", valorTotal, destacado: true)
        ]
        return tarjetaLista(filas)
    }

    /// Fila tocable con título a la izquierda, valor y flecha › a la derecha.
    private func filaElegible(_ titulo: String, _ valor: UILabel, accion: Selector) -> UIView {
        let etiqueta = UILabel()
        etiqueta.text = titulo
        etiqueta.font = .preferredFont(forTextStyle: .body)
        etiqueta.setContentHuggingPriority(.required, for: .horizontal)
        etiqueta.setContentCompressionResistancePriority(.required, for: .horizontal)

        let flecha = UIImageView(image: UIImage(systemName: "chevron.right"))
        flecha.tintColor = .tertiaryLabel
        flecha.preferredSymbolConfiguration = .init(pointSize: 14, weight: .semibold)
        flecha.setContentHuggingPriority(.required, for: .horizontal)

        let fila = UIStackView(arrangedSubviews: [etiqueta, valor, flecha])
        fila.spacing = 8
        fila.alignment = .center
        fila.isUserInteractionEnabled = true
        fila.addGestureRecognizer(UITapGestureRecognizer(target: self, action: accion))
        fila.accessibilityTraits = .button
        return fila
    }

    private func filaResumen(_ titulo: String, _ valor: UILabel, destacado: Bool = false) -> UIView {
        let etiqueta = UILabel()
        etiqueta.text = titulo
        return filaResumen(etiqueta, valor, destacado: destacado)
    }

    private func filaResumen(_ etiqueta: UILabel, _ valor: UILabel, destacado: Bool = false) -> UIView {
        let peso: UIFont.Weight = destacado ? .bold : .regular
        etiqueta.font = .systemFont(ofSize: 17, weight: peso)
        valor.font = .monospacedDigitSystemFont(ofSize: 17, weight: peso)
        valor.textAlignment = .right
        return UIStackView(arrangedSubviews: [etiqueta, valor])
    }

    /// Tarjeta blanca con filas separadas por líneas finas, como una lista agrupada.
    private func tarjetaLista(_ filas: [UIView]) -> UIView {
        let pila = UIStackView()
        pila.axis = .vertical
        pila.translatesAutoresizingMaskIntoConstraints = false

        for (indice, fila) in filas.enumerated() {
            let celda = UIView()
            fila.translatesAutoresizingMaskIntoConstraints = false
            celda.addSubview(fila)
            NSLayoutConstraint.activate([
                fila.topAnchor.constraint(equalTo: celda.topAnchor, constant: 8),
                fila.bottomAnchor.constraint(equalTo: celda.bottomAnchor, constant: -8),
                fila.leadingAnchor.constraint(equalTo: celda.leadingAnchor, constant: 16),
                fila.trailingAnchor.constraint(equalTo: celda.trailingAnchor, constant: -16),
                celda.heightAnchor.constraint(greaterThanOrEqualToConstant: 48)
            ])
            pila.addArrangedSubview(celda)

            if indice < filas.count - 1 {
                let linea = UIView()
                linea.backgroundColor = .separator
                let escala = max(traitCollection.displayScale, 1)
                linea.heightAnchor.constraint(equalToConstant: 1 / escala).isActive = true
                let contenedor = UIView()
                linea.translatesAutoresizingMaskIntoConstraints = false
                contenedor.addSubview(linea)
                NSLayoutConstraint.activate([
                    linea.topAnchor.constraint(equalTo: contenedor.topAnchor),
                    linea.bottomAnchor.constraint(equalTo: contenedor.bottomAnchor),
                    linea.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 16),
                    linea.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor)
                ])
                pila.addArrangedSubview(contenedor)
            }
        }

        let tarjeta = UIView()
        tarjeta.backgroundColor = .secondarySystemGroupedBackground
        tarjeta.layer.cornerRadius = 12
        tarjeta.clipsToBounds = true
        tarjeta.addSubview(pila)
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: tarjeta.topAnchor),
            pila.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor),
            pila.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor),
            pila.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor)
        ])
        return tarjeta
    }

    // MARK: - Selectores (sin cambios)

    @objc private func elegirCliente() {
        let pedido: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        pedido.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true,
                                                   selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        let clientes = (try? contexto.fetch(pedido)) ?? []
        guard !clientes.isEmpty else {
            return mostrarAviso("No hay clientes", "Registra un cliente en la pestaña Clientes.")
        }
        let opciones = clientes.map { c in
            ("\(c.nombre ?? "-")  ·  \(c.categoria().rawValue)", { [weak self] in
                self?.cliente = c
                self?.actualizar()
            })
        }
        mostrarLista("Elige un cliente", opciones, desde: valorCliente)
    }

    @objc private func elegirProducto() {
        let pedido: NSFetchRequest<Producto> = Producto.fetchRequest()
        pedido.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true,
                                                   selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        let productos = (try? contexto.fetch(pedido)) ?? []
        guard !productos.isEmpty else {
            return mostrarAviso("No hay productos", "Pide a un supervisor que registre productos.")
        }
        let opciones = productos.map { p in
            ("\(p.nombre ?? "-")  ·  \(UI.soles(p.precio))  ·  stock \(p.stock)", { [weak self] in
                self?.producto = p
                self?.actualizar()
            })
        }
        mostrarLista("Elige un producto", opciones, desde: valorProducto)
    }

    private func mostrarLista(_ titulo: String, _ opciones: [(String, () -> Void)], desde vista: UIView) {
        let hoja = UIAlertController(title: titulo, message: nil, preferredStyle: .actionSheet)
        for (texto, accion) in opciones {
            hoja.addAction(UIAlertAction(title: texto, style: .default) { _ in accion() })
        }
        hoja.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        hoja.popoverPresentationController?.sourceView = vista
        hoja.popoverPresentationController?.sourceRect = vista.bounds
        present(hoja, animated: true)
    }

    @objc private func cambioCantidad() {
        actualizar()
    }

    // MARK: - Resumen

    private func actualizar() {
        valorCliente.text = cliente?.nombre ?? "Elegir"
        valorCliente.textColor = cliente == nil ? .tertiaryLabel : .secondaryLabel
        valorProducto.text = producto?.nombre ?? "Elegir"
        valorProducto.textColor = producto == nil ? .tertiaryLabel : .secondaryLabel

        labelStock.text = producto.map { "(stock \($0.stock))" } ?? "(stock -)"
        labelCantidad.text = "\(cantidad)"

        let calculo = calculoActual()
        valorSubtotal.text = UI.soles(calculo?.subtotal ?? 0)
        if let descuento = calculo?.descuento, descuento > 0 {
            etiquetaDescuento.text = "Descuento VIP 10%"
            valorDescuento.text = "- \(UI.soles(descuento))"
            valorDescuento.textColor = .systemGreen
        } else {
            etiquetaDescuento.text = "Descuento"
            valorDescuento.text = UI.soles(0)
            valorDescuento.textColor = .label
        }
        valorIGV.text = UI.soles(calculo?.igv ?? 0)
        valorTotal.text = UI.soles(calculo?.total ?? 0)
    }

    /// Sin producto no hay nada que calcular. Sin cliente se calcula sin descuento.
    private func calculoActual() -> CalculoVenta? {
        guard let producto else { return nil }
        return CalculoVenta(cantidad: cantidad, precio: producto.precio,
                            esVIP: cliente?.categoria() == .vip)
    }

    // MARK: - Registrar (sin cambios)

    @objc private func registrar() {
        guard let vendedor = Sesion.shared.usuarioActual else {
            return mostrarAviso("Sesión no válida", "Vuelve a iniciar sesión.")
        }
        guard let cliente, let producto else {
            return mostrarAviso("Faltan datos", "Elige un cliente y un producto.")
        }
        guard Int32(cantidad) <= producto.stock else {
            return mostrarAviso("Stock insuficiente: hay \(producto.stock) unidades", nil)
        }
        guard let calculo = calculoActual() else { return }

        let venta = Venta(context: contexto)
        venta.fecha = Date()
        venta.cantidad = Int32(cantidad)
        venta.precioUnitario = calculo.precioUnitario
        venta.descuento = calculo.descuento
        venta.igv = calculo.igv
        venta.total = calculo.total
        venta.anulada = false
        venta.vendedor = vendedor
        venta.producto = producto
        venta.cliente = cliente
        producto.stock -= Int32(cantidad)

        do {
            try contexto.save()
        } catch {
            contexto.rollback()
            actualizar()
            return mostrarAviso("No se pudo registrar la venta", error.localizedDescription)
        }

        mostrarAviso("Venta registrada", "Total: \(UI.soles(calculo.total))")
        limpiar()
    }

    private func limpiar() {
        cliente = nil
        producto = nil
        stepper.value = 1
        actualizar()
    }

    private func mostrarAviso(_ titulo: String, _ mensaje: String?) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
