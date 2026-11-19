import UIKit

/// Fila con forma de tarjeta flotante: franja de color a la izquierda, ícono,
/// título, subtítulo y una columna de datos a la derecha.
final class CeldaTarjeta: UITableViewCell {

    static let id = "CeldaTarjeta"

    let tarjeta = Tarjeta()
    let franja = UIView()
    let icono = UIImageView()
    let titulo = UILabel()
    let subtitulo = UILabel()
    private let lateral = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        franja.layer.cornerRadius = 2
        icono.contentMode = .scaleAspectFit

        titulo.font = Tema.fuente(16, .semibold)
        titulo.numberOfLines = 1
        subtitulo.font = Tema.fuente(13)
        subtitulo.textColor = Tema.textoSecundario
        subtitulo.numberOfLines = 0

        let textos = UIStackView(arrangedSubviews: [titulo, subtitulo])
        textos.axis = .vertical
        textos.spacing = 3

        lateral.axis = .vertical
        lateral.alignment = .trailing
        lateral.spacing = 6
        lateral.setContentHuggingPriority(.required, for: .horizontal)
        lateral.setContentCompressionResistancePriority(.required, for: .horizontal)

        let fila = UIStackView(arrangedSubviews: [icono, textos, lateral])
        fila.spacing = 12
        fila.alignment = .center

        for vista in [tarjeta, franja, fila] as [UIView] {
            vista.translatesAutoresizingMaskIntoConstraints = false
        }
        contentView.addSubview(tarjeta)
        tarjeta.addSubview(franja)
        tarjeta.addSubview(fila)

        NSLayoutConstraint.activate([
            tarjeta.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            tarjeta.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            tarjeta.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Tema.margen),
            tarjeta.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Tema.margen),

            franja.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 8),
            franja.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 16),
            franja.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -16),
            franja.widthAnchor.constraint(equalToConstant: 4),

            fila.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 14),
            fila.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -14),
            fila.leadingAnchor.constraint(equalTo: franja.trailingAnchor, constant: 10),
            fila.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -16),

            icono.widthAnchor.constraint(equalToConstant: 44),
            icono.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    /// Reemplaza las vistas de la columna derecha.
    func ponerLateral(_ vistas: [UIView]) {
        lateral.arrangedSubviews.forEach { $0.removeFromSuperview() }
        vistas.forEach { lateral.addArrangedSubview($0) }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titulo.attributedText = nil
        subtitulo.attributedText = nil
        titulo.textColor = .label
        subtitulo.textColor = Tema.textoSecundario
        ponerLateral([])
        contentView.alpha = 1
        contentView.transform = .identity
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState]) {
            self.tarjeta.transform = highlighted ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
        }
    }
}

extension UITableView {
    /// Tabla sin líneas, con el fondo del tema, lista para filas tipo tarjeta.
    func prepararParaTarjetas() {
        register(CeldaTarjeta.self, forCellReuseIdentifier: CeldaTarjeta.id)
        backgroundColor = Tema.fondo
        separatorStyle = .none
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 84
        contentInset.top = 4
    }
}
