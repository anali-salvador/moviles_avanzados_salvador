import UIKit

class DetalleViewController: UIViewController {

    @IBOutlet weak var imagenImageView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var opcionLabel: UILabel!
    @IBOutlet weak var textoTextView: UITextView!

    var cultura: Cultura?
    var opcion: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = opcion

        view.backgroundColor = .crema

        imagenImageView.layer.cornerRadius = 16
        imagenImageView.layer.borderWidth = 2
        imagenImageView.layer.borderColor = UIColor.dorado.cgColor
        imagenImageView.clipsToBounds = true

        nombreLabel.font = UIFont.boldSystemFont(ofSize: 28)
        nombreLabel.textColor = .vino

        textoTextView.backgroundColor = .white
        textoTextView.layer.cornerRadius = 16
        textoTextView.layer.borderWidth = 0
        textoTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textoTextView.textContainer.lineFragmentPadding = 0

        guard let cultura = cultura else { return }

        imagenImageView.image = UIImage(named: cultura.imagen)
        nombreLabel.text = cultura.nombre
        opcionLabel.attributedText = NSAttributedString(string: opcion?.uppercased() ?? "", attributes: [
            .font: UIFont.systemFont(ofSize: 13, weight: .semibold),
            .foregroundColor: UIColor.terracota,
            .kern: 1.5
        ])

        var texto = ""
        switch opcion {
        case "Nombre":
            texto = cultura.significado + "\n\n" + "Periodo: " + cultura.periodo
        case "Región":
            texto = "Ubicación: " + cultura.region + "\n\n" + cultura.detalleRegion
        case "Descripción":
            texto = cultura.descripcion
        default:
            break
        }
        mostrarTexto(texto)
    }

    func mostrarTexto(_ texto: String) {
        let estilo = NSMutableParagraphStyle()
        estilo.lineSpacing = 6
        textoTextView.attributedText = NSAttributedString(string: texto, attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.marronOscuro,
            .paragraphStyle: estilo
        ])
    }

}
