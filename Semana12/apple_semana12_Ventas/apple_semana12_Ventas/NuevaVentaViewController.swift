import UIKit
import CoreData

/// Pantalla A5: registrar una venta (Vendedor).
class NuevaVentaViewController: UIViewController {

    private var cliente: Cliente?
    private var producto: Producto?
    private var cantidad: Int { Int(stepper.value) }

    private let labelVendedor = UILabel()
    private let botonCliente = UIButton(configuration: .gray())
    private let botonProducto = UIButton(configuration: .gray())
    private let labelStock = UILabel()
    private let labelCantidad = UILabel()
    private let stepper = UIStepper()

    private let valorPrecio = UILabel()
    private let valorSubtotal = UILabel()
    private let valorDescuento = UILabel()
    private let valorIGV = UILabel()
    private let valorTotal = UILabel()

    private var contexto: NSManagedObjectContext { UI.contexto }

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Venta"
        view.backgroundColor = .systemBackground

        labelVendedor.text = Sesion.shared.usuarioActual?.nombre ?? "-"
        labelVendedor.font = .preferredFont(forTextStyle: .body)

        for boton in [botonCliente, botonProducto] {
            boton.configuration?.titleAlignment = .leading
            boton.contentHorizontalAlignment = .leading
            boton.configuration?.image = UIImage(systemName: "chevron.up.chevron.down")
            boton.configuration?.imagePlacement = .trailing
            boton.configuration?.imagePadding = 8
            boton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        }
        botonCliente.addTarget(self, action: #selector(elegirCliente), for: .touchUpInside)
        botonProducto.addTarget(self, action: #selector(elegirProducto), for: .touchUpInside)

        labelStock.font = .preferredFont(forTextStyle: .footnote)
        labelStock.textColor = .secondaryLabel

        stepper.minimumValue = 1
        stepper.maximumValue = 999
        stepper.value = 1
        stepper.addTarget(self, action: #selector(cambioCantidad), for: .valueChanged)
        labelCantidad.font = .monospacedDigitSystemFont(ofSize: 17, weight: .regular)
        let filaCantidad = UIStackView(arrangedSubviews: [labelCantidad, stepper])
        filaCantidad.alignment = .center

        let resumen = UIStackView(arrangedSubviews: [
            fila("Precio unitario", valorPrecio),
            fila("Subtotal", valorSubtotal),
            fila("Descuento", valorDescuento),
            fila("IGV (18%)", valorIGV),
            fila("Total", valorTotal, destacado: true)
        ])
        resumen.axis = .vertical
        resumen.spacing = 8
        resumen.isLayoutMarginsRelativeArrangement = true
        resumen.directionalLayoutMargins = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
        resumen.backgroundColor = .secondarySystemBackground
        resumen.layer.cornerRadius = 12

        let botonRegistrar = UI.boton("Registrar venta")
        botonRegistrar.addTarget(self, action: #selector(registrar), for: .touchUpInside)

        let pila = UI.pila([
            seccion("Vendedor"), labelVendedor,
            seccion("Cliente"), botonCliente,
            seccion("Producto"), botonProducto, labelStock,
            seccion("Cantidad"), filaCantidad,
            resumen, botonRegistrar
        ], en: view)
        pila.setCustomSpacing(4, after: labelStock)
        pila.setCustomSpacing(24, after: filaCantidad)
        pila.setCustomSpacing(24, after: resumen)
        // Cada encabezado de sección queda pegado a su control.
        for vista in pila.arrangedSubviews where vista.tag == Self.tagSeccion {
            pila.setCustomSpacing(4, after: vista)
        }

        actualizar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Clientes o productos pueden haber cambiado en otras pestañas.
        if let cliente, cliente.isDeleted || cliente.managedObjectContext == nil { self.cliente = nil }
        if let producto, producto.isDeleted || producto.managedObjectContext == nil { self.producto = nil }
        actualizar()
    }

    // MARK: - Selectores

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
        mostrarLista("Elige un cliente", opciones, desde: botonCliente)
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
        mostrarLista("Elige un producto", opciones, desde: botonProducto)
    }

    private func mostrarLista(_ titulo: String, _ opciones: [(String, () -> Void)], desde boton: UIButton) {
        let hoja = UIAlertController(title: titulo, message: nil, preferredStyle: .actionSheet)
        for (texto, accion) in opciones {
            hoja.addAction(UIAlertAction(title: texto, style: .default) { _ in accion() })
        }
        hoja.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        hoja.popoverPresentationController?.sourceView = boton
        hoja.popoverPresentationController?.sourceRect = boton.bounds
        present(hoja, animated: true)
    }

    @objc private func cambioCantidad() {
        actualizar()
    }

    // MARK: - Resumen

    private func actualizar() {
        if let cliente {
            botonCliente.configuration?.title = "\(cliente.nombre ?? "-")  ·  \(cliente.categoria().rawValue)"
        } else {
            botonCliente.configuration?.title = "Elegir cliente"
        }

        if let producto {
            botonProducto.configuration?.title = producto.nombre ?? "-"
            labelStock.text = "Stock disponible: \(producto.stock)"
            labelStock.textColor = ProductosViewController.colorStock(producto.stock)
        } else {
            botonProducto.configuration?.title = "Elegir producto"
            labelStock.text = "Stock disponible: -"
            labelStock.textColor = .secondaryLabel
        }

        labelCantidad.text = "Cantidad: \(cantidad)"

        let calculo = calculoActual()
        valorPrecio.text = UI.soles(calculo?.precioUnitario ?? 0)
        valorSubtotal.text = UI.soles(calculo?.subtotal ?? 0)
        valorDescuento.text = UI.soles(calculo?.descuento ?? 0)
        valorIGV.text = UI.soles(calculo?.igv ?? 0)
        valorTotal.text = UI.soles(calculo?.total ?? 0)
    }

    /// Sin producto no hay nada que calcular. Sin cliente se calcula sin descuento.
    private func calculoActual() -> CalculoVenta? {
        guard let producto else { return nil }
        return CalculoVenta(cantidad: cantidad, precio: producto.precio,
                            esVIP: cliente?.categoria() == .vip)
    }

    // MARK: - Registrar

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

    // MARK: - Ayudas de vista

    private static let tagSeccion = 900

    private func seccion(_ texto: String) -> UILabel {
        let label = UILabel()
        label.tag = Self.tagSeccion
        label.text = texto.uppercased()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }

    private func fila(_ titulo: String, _ valor: UILabel, destacado: Bool = false) -> UIStackView {
        let etiqueta = UILabel()
        etiqueta.text = titulo
        let peso: UIFont.Weight = destacado ? .bold : .regular
        etiqueta.font = .systemFont(ofSize: 17, weight: peso)
        valor.font = .monospacedDigitSystemFont(ofSize: 17, weight: peso)
        valor.textAlignment = .right
        return UIStackView(arrangedSubviews: [etiqueta, valor])
    }

    private func mostrarAviso(_ titulo: String, _ mensaje: String?) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
