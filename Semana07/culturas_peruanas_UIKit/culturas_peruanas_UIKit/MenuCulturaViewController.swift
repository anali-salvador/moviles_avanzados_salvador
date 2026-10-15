import UIKit

class MenuCulturaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var cultura: Cultura?
    let opciones = ["Nombre", "Región", "Descripción"]
    let iconos = ["textformat", "map", "doc.text"]
    let subtitulos = ["Origen y significado", "Dónde vivieron", "Su historia y logros"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = cultura?.nombre
        navigationItem.largeTitleDisplayMode = .never

        view.backgroundColor = .crema
        tableView.backgroundColor = .crema
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opciones.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "opcion", for: indexPath)

        var contenido = UIListContentConfiguration.subtitleCell()
        contenido.text = opciones[indexPath.row]
        contenido.textProperties.font = UIFont.boldSystemFont(ofSize: 18)
        contenido.textProperties.color = .marronOscuro
        contenido.secondaryText = subtitulos[indexPath.row]
        contenido.secondaryTextProperties.font = UIFont.systemFont(ofSize: 14)
        contenido.secondaryTextProperties.color = .grisCalido
        contenido.textToSecondaryTextVerticalPadding = 4
        contenido.image = UIImage(systemName: iconos[indexPath.row])
        contenido.imageProperties.tintColor = .terracota
        contenido.imageProperties.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        contenido.imageProperties.reservedLayoutSize = CGSize(width: 32, height: 32)
        contenido.imageToTextPadding = 14
        contenido.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 22, leading: 28, bottom: 22, trailing: 8)
        celda.contentConfiguration = contenido

        Estilo.aplicarTarjeta(a: celda)
        return celda
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let ancho = tableView.bounds.width
        let altoFoto: CGFloat = 220
        let encabezado = UIView(frame: CGRect(x: 0, y: 0, width: ancho, height: altoFoto + 12))
        encabezado.backgroundColor = .crema

        let foto = UIImageView(frame: CGRect(x: 0, y: 0, width: ancho, height: altoFoto))
        foto.image = UIImage(named: cultura?.imagen ?? "")
        foto.contentMode = .scaleAspectFill
        foto.clipsToBounds = true
        encabezado.addSubview(foto)

        // Degradado negro semitransparente en la parte de abajo para que el texto blanco se lea bien
        let degradado = CAGradientLayer()
        degradado.frame = CGRect(x: 0, y: altoFoto * 0.4, width: ancho, height: altoFoto * 0.6)
        degradado.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        foto.layer.addSublayer(degradado)

        let nombre = UILabel(frame: CGRect(x: 20, y: altoFoto - 82, width: ancho - 40, height: 40))
        nombre.text = cultura?.nombre
        nombre.font = UIFont.boldSystemFont(ofSize: 32)
        nombre.textColor = .white
        foto.addSubview(nombre)

        let lema = UILabel(frame: CGRect(x: 20, y: altoFoto - 40, width: ancho - 40, height: 20))
        lema.text = "Conoce su historia"
        lema.font = UIFont.systemFont(ofSize: 15)
        lema.textColor = .white
        foto.addSubview(lema)

        return encabezado
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 232
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irDetalle" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destino = segue.destination as? DetalleViewController else { return }
            destino.cultura = cultura
            destino.opcion = opciones[indexPath.row]
        }
    }

}
