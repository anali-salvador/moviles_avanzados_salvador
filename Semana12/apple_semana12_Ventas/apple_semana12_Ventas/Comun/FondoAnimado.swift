import UIKit

/// Fondo de Login y Registro: degradado diagonal que cambia lentamente entre
/// azul noche, teal y verde esmeralda, con círculos translúcidos que flotan.
final class FondoAnimado: UIView {

    override class var layerClass: AnyClass { CAGradientLayer.self }
    private var degradado: CAGradientLayer { layer as! CAGradientLayer }

    /// Posición (fracción del ancho y alto), diámetro y opacidad de cada círculo.
    private let disposicion: [(x: CGFloat, y: CGFloat, lado: CGFloat, alfa: CGFloat)] = [
        (0.15, 0.18, 170, 0.10),
        (0.85, 0.10, 90, 0.14),
        (0.78, 0.45, 220, 0.07),
        (0.10, 0.62, 110, 0.12),
        (0.55, 0.85, 150, 0.09),
        (0.92, 0.80, 60, 0.18)
    ]
    private var circulos: [UIView] = []
    private var activo = false

    private let coloresA = [Tema.azulNoche, Tema.principalOscuro, Tema.esmeralda].map(\.cgColor)
    private let coloresB = [Tema.principalOscuro, Tema.esmeralda, Tema.azulNoche].map(\.cgColor)

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        degradado.colors = coloresA
        degradado.startPoint = CGPoint(x: 0, y: 0)
        degradado.endPoint = CGPoint(x: 1, y: 1)

        for item in disposicion {
            let circulo = UIView()
            circulo.backgroundColor = UIColor.white.withAlphaComponent(item.alfa)
            circulo.bounds.size = CGSize(width: item.lado, height: item.lado)
            circulo.layer.cornerRadius = item.lado / 2
            addSubview(circulo)
            circulos.append(circulo)
        }

        // Al volver del segundo plano el sistema quita las animaciones: se reinician.
        NotificationCenter.default.addObserver(self, selector: #selector(volvioAlFrente),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func layoutSubviews() {
        super.layoutSubviews()
        for (circulo, item) in zip(circulos, disposicion) {
            circulo.center = CGPoint(x: bounds.width * item.x, y: bounds.height * item.y)
        }
    }

    // MARK: - Animaciones

    func iniciar() {
        detener()
        activo = true

        let colores = CABasicAnimation(keyPath: "colors")
        colores.fromValue = coloresA
        colores.toValue = coloresB
        colores.duration = 8
        colores.autoreverses = true
        colores.repeatCount = .infinity
        colores.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        degradado.add(colores, forKey: "colores")

        for (indice, circulo) in circulos.enumerated() {
            let paso = CGFloat(indice)
            let subir = CABasicAnimation(keyPath: "transform.translation.y")
            subir.fromValue = 0
            subir.toValue = -(40 + paso * 12)
            subir.duration = 6 + Double(indice) * 1.3

            let lado = CABasicAnimation(keyPath: "transform.translation.x")
            lado.fromValue = 0
            lado.toValue = (indice.isMultiple(of: 2) ? 1 : -1) * (24 + paso * 6)
            lado.duration = 5 + Double(indice) * 0.9

            for animacion in [subir, lado] {
                animacion.autoreverses = true
                animacion.repeatCount = .infinity
                animacion.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            }
            circulo.layer.add(subir, forKey: "subir")
            circulo.layer.add(lado, forKey: "lado")
        }
    }

    func detener() {
        activo = false
        degradado.removeAllAnimations()
        circulos.forEach { $0.layer.removeAllAnimations() }
    }

    @objc private func volvioAlFrente() {
        if activo { iniciar() }
    }
}

extension UIViewController {
    /// Pone el fondo animado detrás de todo el contenido de la pantalla.
    func agregarFondoAnimado() -> FondoAnimado {
        let fondo = FondoAnimado()
        fondo.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(fondo, at: 0)
        NSLayoutConstraint.activate([
            fondo.topAnchor.constraint(equalTo: view.topAnchor),
            fondo.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            fondo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fondo.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return fondo
    }
}
