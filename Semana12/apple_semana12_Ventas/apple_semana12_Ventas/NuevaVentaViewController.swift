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
        view.backgroundColor = Tema.fondo

        stepper.minimumValue = 1
        stepper.maximumValue = 999
        stepper.value = 1
        stepper.addTarget(self, action: #selector(cambioCantidad), for: .valueChanged)

        let botonRegistrar = Tema.botonAcento("Registrar venta", icono: "checkmark.circle.fill")
        botonRegistrar.addTarget(self, action: #selector(registrar), for: .touchUpInside)

        let etiquetaDatos = Tema.etiqueta("Datos de la venta")
        let etiquetaResumen = Tema.etiqueta("Resumen (calculado)")
        let vendedor = tarjetaVendedor()
        let cantidad = tarjetaCantidad()
        let total = tarjetaTotal()

        let pila = UI.pila([
            vendedor,
            etiquetaDatos,
            tarjetaElegible("Cliente", "person.fill", valorCliente, accion: #selector(elegirCliente)),
            tarjetaElegible("Producto", "shippingbox.fill", valorProducto, accion: #selector(elegirProducto)),
            cantidad,
            etiquetaResumen, tarjetaResumen(), total,
            botonRegistrar
        ], en: view)
        pila.spacing = 12
        pila.setCustomSpacing(24, after: vendedor)
        pila.setCustomSpacing(4, after: etiquetaDatos)
        pila.setCustomSpacing(24, after: cantidad)
        pila.setCustomSpacing(4, after: etiquetaResumen)
        pila.setCustomSpacing(24, after: total)
        Tema.animarEntrada(pila.arrangedSubviews, paso: 0.04)

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

    /// Tarjeta con degradado teal: iniciales y nombre del vendedor de la sesión en blanco.
    private func tarjetaVendedor() -> UIView {
        let usuario = Sesion.shared.usuarioActual

        let circulo = UILabel()
        circulo.text = UI.iniciales(de: usuario?.nombre)
        circulo.font = Tema.fuente(18, .bold)
        circulo.textColor = .white
        circulo.textAlignment = .center
        circulo.backgroundColor = UIColor.white.withAlphaComponent(0.22)
        circulo.layer.cornerRadius = 26
        circulo.layer.borderWidth = 2
        circulo.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        circulo.clipsToBounds = true
        circulo.widthAnchor.constraint(equalToConstant: 52).isActive = true
        circulo.heightAnchor.constraint(equalToConstant: 52).isActive = true

        let saludo = UILabel()
        saludo.text = "VENDEDOR · \((usuario?.rol ?? "Vendedor").uppercased())"
        saludo.font = Tema.fuente(11, .bold)
        saludo.textColor = UIColor.white.withAlphaComponent(0.75)

        let nombre = UILabel()
        nombre.text = usuario?.nombre ?? "-"
        nombre.font = Tema.fuente(20, .bold)
        nombre.textColor = .white
        nombre.numberOfLines = 0

        let nota = UILabel()
        nota.text = "Sesión iniciada · la venta se registra a tu nombre"
        nota.font = Tema.fuente(12, .medium)
        nota.textColor = UIColor.white.withAlphaComponent(0.85)
        nota.numberOfLines = 0

        let textos = UIStackView(arrangedSubviews: [saludo, nombre, nota])
        textos.axis = .vertical
        textos.spacing = 2

        let fila = UIStackView(arrangedSubviews: [circulo, textos])
        fila.spacing = 14
        fila.alignment = .center
        return Tema.tarjetaDegradado(fila)
    }

    /// Tarjeta tocable: ícono, título pequeño, valor elegido y flecha ›.
    private func tarjetaElegible(_ titulo: String, _ simbolo: String, _ valor: UILabel, accion: Selector) -> UIView {
        valor.font = Tema.fuente(17, .semibold)
        valor.lineBreakMode = .byTruncatingTail

        let textos = UIStackView(arrangedSubviews: [Tema.etiqueta(titulo), valor])
        textos.axis = .vertical
        textos.spacing = 3

        let flecha = UIImageView(image: UIImage(systemName: "chevron.right.circle.fill"))
        flecha.tintColor = Tema.principal
        flecha.preferredSymbolConfiguration = .init(pointSize: 22, weight: .semibold)
        flecha.setContentHuggingPriority(.required, for: .horizontal)

        let fila = UIStackView(arrangedSubviews: [Tema.icono(simbolo), textos, flecha])
        fila.spacing = 12
        fila.alignment = .center

        let tarjeta = Tema.tarjeta(fila, relleno: 14)
        tarjeta.addGestureRecognizer(UITapGestureRecognizer(target: self, action: accion))
        tarjeta.isAccessibilityElement = true
        tarjeta.accessibilityLabel = titulo
        tarjeta.accessibilityTraits = .button
        return tarjeta
    }

    /// Cantidad con el stock disponible y el stepper.
    private func tarjetaCantidad() -> UIView {
        labelStock.font = Tema.fuente(13, .medium)
        labelStock.textColor = Tema.textoSecundario
        labelCantidad.font = Tema.numero(26, .bold)
        labelCantidad.textColor = Tema.principal
        labelCantidad.setContentHuggingPriority(.required, for: .horizontal)
        stepper.setContentHuggingPriority(.required, for: .horizontal)

        let textos = UIStackView(arrangedSubviews: [Tema.etiqueta("Cantidad"), labelStock])
        textos.axis = .vertical
        textos.spacing = 3

        let fila = UIStackView(arrangedSubviews: [Tema.icono("number"), textos, UIView(), labelCantidad, stepper])
        fila.spacing = 12
        fila.alignment = .center
        return Tema.tarjeta(fila, relleno: 14)
    }

    /// Subtotal, Descuento e IGV 18%.
    private func tarjetaResumen() -> UIView {
        let filas = UIStackView(arrangedSubviews: [
            filaResumen("Subtotal", valorSubtotal),
            filaResumen(etiquetaDescuento, valorDescuento),
            filaResumen("IGV 18%", valorIGV)
        ])
        filas.axis = .vertical
        filas.spacing = 12
        return Tema.tarjeta(filas)
    }

    /// Total destacado con letra grande.
    private func tarjetaTotal() -> UIView {
        let titulo = Tema.etiqueta("Total a pagar", color: Tema.principal)
        let nota = UILabel()
        nota.text = "IGV incluido"
        nota.font = Tema.fuente(12, .medium)
        nota.textColor = Tema.textoSecundario

        let textos = UIStackView(arrangedSubviews: [titulo, nota])
        textos.axis = .vertical
        textos.spacing = 2

        valorTotal.font = Tema.numero(34, .heavy)
        valorTotal.textColor = Tema.principal
        valorTotal.textAlignment = .right
        valorTotal.adjustsFontSizeToFitWidth = true
        valorTotal.minimumScaleFactor = 0.5

        let fila = UIStackView(arrangedSubviews: [textos, valorTotal])
        fila.spacing = 12
        fila.alignment = .center
        fila.translatesAutoresizingMaskIntoConstraints = false

        let tarjeta = UIView()
        tarjeta.backgroundColor = Tema.dinamico(UIColor(hex: 0xE6F4F2), UIColor(hex: 0x123A3B))
        tarjeta.layer.cornerRadius = Tema.radio
        tarjeta.layer.cornerCurve = .continuous
        tarjeta.layer.borderWidth = 2
        tarjeta.layer.borderColor = Tema.principalClaro.withAlphaComponent(0.45).cgColor
        tarjeta.addSubview(fila)
        NSLayoutConstraint.activate([
            fila.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 18),
            fila.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -18),
            fila.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 18),
            fila.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -18)
        ])
        return tarjeta
    }

    private func filaResumen(_ titulo: String, _ valor: UILabel) -> UIView {
        let etiqueta = UILabel()
        etiqueta.text = titulo
        return filaResumen(etiqueta, valor)
    }

    private func filaResumen(_ etiqueta: UILabel, _ valor: UILabel) -> UIView {
        etiqueta.font = Tema.fuente(16, .medium)
        etiqueta.textColor = Tema.textoSecundario
        valor.font = Tema.numero(16, .semibold)
        valor.textAlignment = .right
        return UIStackView(arrangedSubviews: [etiqueta, valor])
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
        valorCliente.textColor = cliente == nil ? .tertiaryLabel : .label
        valorProducto.text = producto?.nombre ?? "Elegir"
        valorProducto.textColor = producto == nil ? .tertiaryLabel : .label

        labelStock.text = producto.map { "(stock \($0.stock))" } ?? "(stock -)"
        labelCantidad.text = "\(cantidad)"

        let calculo = calculoActual()
        valorSubtotal.text = UI.soles(calculo?.subtotal ?? 0)
        if let descuento = calculo?.descuento, descuento > 0 {
            etiquetaDescuento.text = "Descuento VIP 10%"
            valorDescuento.text = "- \(UI.soles(descuento))"
            valorDescuento.textColor = Tema.exito
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
