import UIKit

/// Paleta, fuentes y piezas visuales de toda la app, en un solo lugar.
/// Todos los colores se adaptan al modo claro y al modo oscuro.
enum Tema {

    // MARK: - Colores

    /// Verde azulado (teal) #0F766E. En modo oscuro se aclara para que se lea sobre el fondo azul noche.
    static let principal = dinamico(UIColor(hex: 0x0F766E), UIColor(hex: 0x2DD4BF))
    /// Teal claro, para el inicio de los degradados.
    static let principalClaro = UIColor(hex: 0x14B8A6)
    /// Teal oscuro, para el final de los degradados.
    static let principalOscuro = UIColor(hex: 0x0F766E)
    /// Naranja coral #F97316.
    static let acento = UIColor(hex: 0xF97316)
    static let exito = UIColor(hex: 0x16A34A)
    static let error = UIColor(hex: 0xDC2626)
    static let aviso = UIColor(hex: 0xF59E0B)

    /// Azul noche y verde esmeralda (fondo animado del login).
    static let azulNoche = UIColor(hex: 0x0B1220)
    static let esmeralda = UIColor(hex: 0x047857)

    /// Fondo de las pantallas: gris azulado muy claro / azul noche.
    static let fondo = dinamico(UIColor(hex: 0xF1F5F9), UIColor(hex: 0x0B1220))
    /// Fondo de las tarjetas: blanco / azul pizarra.
    static let tarjeta = dinamico(.white, UIColor(hex: 0x162033))
    /// Fondo suave para íconos y chips sin seleccionar.
    static let suave = dinamico(UIColor(hex: 0xE2F3F1), UIColor(hex: 0x1E2B42))
    /// Texto secundario con un toque azulado.
    static let textoSecundario = dinamico(UIColor(hex: 0x64748B), UIColor(hex: 0x94A3B8))

    static let degradadoTeal: [UIColor] = [principalClaro, principalOscuro]
    static let degradadoCoral: [UIColor] = [UIColor(hex: 0xFB923C), UIColor(hex: 0xC2410C)]

    // MARK: - Medidas

    static let radio: CGFloat = 20
    static let margen: CGFloat = 16

    // MARK: - Fuentes

    /// Fuente del sistema con diseño redondeado.
    static func fuente(_ tamano: CGFloat, _ peso: UIFont.Weight = .regular) -> UIFont {
        redondear(.systemFont(ofSize: tamano, weight: peso))
    }

    /// Fuente redondeada con dígitos de ancho fijo (para montos).
    static func numero(_ tamano: CGFloat, _ peso: UIFont.Weight = .semibold) -> UIFont {
        redondear(.monospacedDigitSystemFont(ofSize: tamano, weight: peso))
    }

    private static func redondear(_ base: UIFont) -> UIFont {
        guard let descriptor = base.fontDescriptor.withDesign(.rounded) else { return base }
        return UIFont(descriptor: descriptor, size: base.pointSize)
    }

    // MARK: - Ayudas de color

    static func dinamico(_ claro: UIColor, _ oscuro: UIColor) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark ? oscuro : claro }
    }

    /// Versión del color que se lee bien como texto: más oscura en claro, más clara en oscuro.
    static func tono(_ color: UIColor) -> UIColor {
        dinamico(color.ajustado(brillo: -0.28), color.ajustado(brillo: 0.22))
    }

    // MARK: - Piezas

    /// Tarjeta con esquinas de 20 puntos y sombra suave, con el contenido dentro.
    static func tarjeta(_ contenido: UIView, relleno: CGFloat = 16) -> Tarjeta {
        let tarjeta = Tarjeta()
        contenido.translatesAutoresizingMaskIntoConstraints = false
        tarjeta.addSubview(contenido)
        NSLayoutConstraint.activate([
            contenido.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: relleno),
            contenido.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -relleno),
            contenido.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: relleno),
            contenido.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -relleno)
        ])
        return tarjeta
    }

    /// Tarjeta con degradado (teal por defecto) y el contenido dentro.
    static func tarjetaDegradado(_ contenido: UIView, colores: [UIColor] = degradadoTeal,
                                 relleno: CGFloat = 18) -> VistaDegradado {
        let fondo = VistaDegradado(colores: colores)
        fondo.layer.cornerRadius = radio
        fondo.layer.cornerCurve = .continuous
        fondo.sombra(color: colores.last ?? principal, opacidad: 0.3, radio: 14, desplazamiento: 6)
        contenido.translatesAutoresizingMaskIntoConstraints = false
        fondo.addSubview(contenido)
        NSLayoutConstraint.activate([
            contenido.topAnchor.constraint(equalTo: fondo.topAnchor, constant: relleno),
            contenido.bottomAnchor.constraint(equalTo: fondo.bottomAnchor, constant: -relleno),
            contenido.leadingAnchor.constraint(equalTo: fondo.leadingAnchor, constant: relleno),
            contenido.trailingAnchor.constraint(equalTo: fondo.trailingAnchor, constant: -relleno)
        ])
        return fondo
    }

    /// Botón principal: degradado teal, texto blanco y esquinas redondeadas.
    static func botonPrincipal(_ titulo: String, icono: String? = nil) -> BotonDegradado {
        let boton = BotonDegradado(colores: degradadoTeal)
        boton.configuration = configuracionBoton(titulo, icono: icono, color: .white)
        boton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        return boton
    }

    /// Botón de acento: naranja coral, esquinas totalmente redondeadas y un brillo suave.
    static func botonAcento(_ titulo: String, icono: String? = nil) -> BotonAnimado {
        var config = configuracionBoton(titulo, icono: icono, color: .white)
        config.background.backgroundColor = acento
        config.cornerStyle = .capsule
        let boton = BotonAnimado(configuration: config)
        boton.sombra(color: acento, opacidad: 0.35, radio: 12, desplazamiento: 6)
        boton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        return boton
    }

    /// Botón suave: fondo del color muy claro y texto del color (por ejemplo, rojo suave).
    static func botonSuave(_ titulo: String, icono: String? = nil, color: UIColor) -> BotonAnimado {
        var config = configuracionBoton(titulo, icono: icono, color: tono(color))
        config.background.backgroundColor = color.withAlphaComponent(0.12)
        config.cornerStyle = .capsule
        let boton = BotonAnimado(configuration: config)
        boton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        return boton
    }

    private static func configuracionBoton(_ titulo: String, icono: String?, color: UIColor) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.title = titulo
        config.baseForegroundColor = color
        if let icono {
            config.image = UIImage(systemName: icono)
            config.imagePadding = 8
            config.preferredSymbolConfigurationForImage = .init(pointSize: 15, weight: .bold)
        }
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
            var nuevos = atributos
            nuevos.font = fuente(17, .bold)
            return nuevos
        }
        return config
    }

    /// Píldora suave: fondo del color muy claro y texto del mismo color, más intenso.
    static func pildora(_ texto: String, color: UIColor, fuente: UIFont = Tema.fuente(12, .bold)) -> UIView {
        let label = UILabel()
        label.text = texto
        label.font = fuente
        label.textColor = tono(color)
        label.translatesAutoresizingMaskIntoConstraints = false

        let fondo = UIView()
        fondo.backgroundColor = color.withAlphaComponent(0.16)
        fondo.layer.cornerRadius = (fuente.lineHeight + 8) / 2
        fondo.layer.cornerCurve = .continuous
        fondo.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: fondo.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: fondo.bottomAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: fondo.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: fondo.trailingAnchor, constant: -10)
        ])
        fondo.setContentHuggingPriority(.required, for: .horizontal)
        fondo.setContentCompressionResistancePriority(.required, for: .horizontal)
        return fondo
    }

    /// Etiqueta de sección: pequeña, en mayúsculas, con letras separadas.
    static func etiqueta(_ texto: String, color: UIColor = textoSecundario) -> UILabel {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: texto.uppercased(), attributes: [
            .font: fuente(12, .bold), .foregroundColor: color, .kern: 0.8
        ])
        return label
    }

    /// Cuadro redondeado con un SF Symbol, sobre fondo suave.
    static func icono(_ simbolo: String, color: UIColor = principal, lado: CGFloat = 40) -> UIView {
        let imagen = UIImageView(image: UIImage(systemName: simbolo))
        imagen.tintColor = color
        imagen.preferredSymbolConfiguration = .init(pointSize: lado * 0.42, weight: .semibold)
        imagen.contentMode = .center
        imagen.backgroundColor = color.withAlphaComponent(0.13)
        imagen.layer.cornerRadius = lado * 0.32
        imagen.layer.cornerCurve = .continuous
        imagen.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imagen.widthAnchor.constraint(equalToConstant: lado),
            imagen.heightAnchor.constraint(equalToConstant: lado)
        ])
        return imagen
    }

    /// Chip redondeado para filtros (categorías, vendedores).
    static func chip(_ titulo: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = titulo
        config.cornerStyle = .capsule
        config.contentInsets = .init(top: 7, leading: 16, bottom: 7, trailing: 16)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { atributos in
            var nuevos = atributos
            nuevos.font = fuente(14, .semibold)
            return nuevos
        }
        return UIButton(configuration: config)
    }

    /// Activo: teal con texto blanco. Inactivo: fondo suave con texto teal.
    static func marcar(chip: UIButton, activo: Bool) {
        chip.configuration?.baseBackgroundColor = activo ? principal : suave
        chip.configuration?.baseForegroundColor = activo ? .white : principal
    }

    /// Selector segmentado con el segmento elegido en teal.
    static func estilizar(_ selector: UISegmentedControl) {
        selector.selectedSegmentTintColor = principal
        selector.backgroundColor = suave
        selector.setTitleTextAttributes([.font: fuente(14, .bold), .foregroundColor: UIColor.white], for: .selected)
        selector.setTitleTextAttributes([.font: fuente(14, .semibold), .foregroundColor: principal], for: .normal)
    }

    /// Texto al pie de una tabla sin estilo agrupado.
    static func pieTabla(_ texto: String, ancho: CGFloat) -> UIView {
        let label = UILabel()
        label.text = texto
        label.font = fuente(12)
        label.textColor = textoSecundario
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        let contenedor = UIView()
        contenedor.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contenedor.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 28),
            label.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -28)
        ])
        contenedor.frame = CGRect(x: 0, y: 0, width: ancho, height: 64)
        return contenedor
    }

    // MARK: - Animación

    /// Aparece con un fundido y un desplazamiento de 8 puntos hacia arriba.
    static func animarEntrada(_ vista: UIView, retraso: TimeInterval = 0) {
        vista.alpha = 0
        vista.transform = CGAffineTransform(translationX: 0, y: 8)
        UIView.animate(withDuration: 0.4, delay: retraso, options: [.curveEaseOut, .allowUserInteraction]) {
            vista.alpha = 1
            vista.transform = .identity
        }
    }

    /// Anima varias vistas una tras otra.
    static func animarEntrada(_ vistas: [UIView], paso: TimeInterval = 0.05) {
        for (indice, vista) in vistas.enumerated() {
            animarEntrada(vista, retraso: Double(indice) * paso)
        }
    }

    // MARK: - Apariencia general

    /// Barras de navegación con títulos grandes redondeados.
    static func aplicarApariencia() {
        let titulo: [NSAttributedString.Key: Any] = [.font: fuente(17, .bold), .foregroundColor: UIColor.label]
        let tituloGrande: [NSAttributedString.Key: Any] = [.font: fuente(34, .bold), .foregroundColor: UIColor.label]

        let normal = UINavigationBarAppearance()
        normal.configureWithDefaultBackground()
        normal.titleTextAttributes = titulo
        normal.largeTitleTextAttributes = tituloGrande

        let borde = UINavigationBarAppearance()
        borde.configureWithTransparentBackground()
        borde.titleTextAttributes = titulo
        borde.largeTitleTextAttributes = tituloGrande

        let barra = UINavigationBar.appearance()
        barra.standardAppearance = normal
        barra.compactAppearance = normal
        barra.scrollEdgeAppearance = borde
        barra.tintColor = principal
    }

    /// Tab bar con fondo desenfocado y el ícono elegido en teal.
    static func estilizar(_ tabBar: UITabBar) {
        let apariencia = UITabBarAppearance()
        apariencia.configureWithDefaultBackground()
        apariencia.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)

        for elemento in [apariencia.stackedLayoutAppearance, apariencia.inlineLayoutAppearance,
                         apariencia.compactInlineLayoutAppearance] {
            elemento.selected.iconColor = principal
            elemento.selected.titleTextAttributes = [.font: fuente(11, .bold), .foregroundColor: principal]
            elemento.normal.iconColor = textoSecundario
            elemento.normal.titleTextAttributes = [.font: fuente(11, .medium), .foregroundColor: textoSecundario]
        }
        tabBar.standardAppearance = apariencia
        tabBar.scrollEdgeAppearance = apariencia
        tabBar.tintColor = principal
        tabBar.unselectedItemTintColor = textoSecundario
    }
}

// MARK: - Animación de filas

/// Hace aparecer cada fila una sola vez, escalonadas solo en la carga inicial.
final class EntradaFilas {
    private var mostradas = Set<IndexPath>()
    private var inicio = Date()

    /// Llamar al volver a la pantalla para que las filas se animen otra vez.
    func reiniciar() {
        mostradas.removeAll()
        inicio = Date()
    }

    func aplicar(a celda: UITableViewCell, en indexPath: IndexPath) {
        guard mostradas.insert(indexPath).inserted else { return }
        let enCargaInicial = Date().timeIntervalSince(inicio) < 0.6
        let retraso = enCargaInicial ? Double(min(indexPath.row, 10)) * 0.045 : 0
        Tema.animarEntrada(celda.contentView, retraso: retraso)
    }
}

// MARK: - Vistas

/// Tarjeta con esquinas de 20 puntos y sombra suave que se adapta al modo oscuro.
class Tarjeta: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Tema.tarjeta
        layer.cornerRadius = Tema.radio
        layer.cornerCurve = .continuous
        actualizarSombra()
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (vista: Tarjeta, _) in
            vista.actualizarSombra()
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    private func actualizarSombra() {
        let oscuro = traitCollection.userInterfaceStyle == .dark
        layer.shadowColor = UIColor(hex: 0x0F172A).cgColor
        layer.shadowOpacity = oscuro ? 0.35 : 0.07
        layer.shadowRadius = oscuro ? 10 : 14
        layer.shadowOffset = CGSize(width: 0, height: oscuro ? 4 : 6)
        layer.borderWidth = oscuro ? 1 : 0
        layer.borderColor = UIColor.white.withAlphaComponent(0.06).cgColor
    }
}

/// Vista con un degradado diagonal de fondo.
class VistaDegradado: UIView {
    override class var layerClass: AnyClass { CAGradientLayer.self }
    var degradado: CAGradientLayer { layer as! CAGradientLayer }

    var colores: [UIColor] { didSet { actualizarColores() } }

    init(colores: [UIColor], inicio: CGPoint = CGPoint(x: 0, y: 0), fin: CGPoint = CGPoint(x: 1, y: 1)) {
        self.colores = colores
        super.init(frame: .zero)
        degradado.startPoint = inicio
        degradado.endPoint = fin
        actualizarColores()
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (vista: VistaDegradado, _) in
            vista.actualizarColores()
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    private func actualizarColores() {
        degradado.colors = colores.map { $0.resolvedColor(with: traitCollection).cgColor }
    }
}

/// Botón que se achica un poco al presionarlo.
class BotonAnimado: UIButton {
    override var isHighlighted: Bool {
        didSet {
            guard oldValue != isHighlighted else { return }
            UIView.animate(withDuration: 0.18, delay: 0,
                           usingSpringWithDamping: 0.6, initialSpringVelocity: 0,
                           options: [.allowUserInteraction, .beginFromCurrentState]) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            }
        }
    }
}

/// Botón con un degradado de fondo y esquinas redondeadas.
final class BotonDegradado: BotonAnimado {
    private let capa = CAGradientLayer()

    init(colores: [UIColor]) {
        super.init(frame: .zero)
        capa.colors = colores.map(\.cgColor)
        capa.startPoint = CGPoint(x: 0, y: 0)
        capa.endPoint = CGPoint(x: 1, y: 1)
        capa.cornerRadius = 16
        capa.cornerCurve = .continuous
        layer.insertSublayer(capa, at: 0)
        sombra(color: colores.last ?? Tema.principal, opacidad: 0.3, radio: 12, desplazamiento: 6)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func layoutSubviews() {
        super.layoutSubviews()
        capa.frame = bounds
    }
}

extension UIView {
    /// Sombra de color (el color se fija una sola vez; para sombras que cambian con el modo usar `Tarjeta`).
    func sombra(color: UIColor, opacidad: Float, radio: CGFloat, desplazamiento: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacidad
        layer.shadowRadius = radio
        layer.shadowOffset = CGSize(width: 0, height: desplazamiento)
    }
}

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        self.init(red: CGFloat((hex >> 16) & 0xFF) / 255,
                  green: CGFloat((hex >> 8) & 0xFF) / 255,
                  blue: CGFloat(hex & 0xFF) / 255,
                  alpha: alpha)
    }

    /// Sube o baja el brillo (valores de -1 a 1).
    func ajustado(brillo: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a) else { return self }
        let nuevoBrillo = min(max(b + brillo, 0), 1)
        let nuevaSaturacion = brillo > 0 ? max(s - brillo * 0.6, 0) : s
        return UIColor(hue: h, saturation: nuevaSaturacion, brightness: nuevoBrillo, alpha: a)
    }
}
