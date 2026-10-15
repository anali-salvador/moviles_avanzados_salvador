import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Culturas Peruanas"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        let apariencia = UINavigationBarAppearance()
        apariencia.configureWithOpaqueBackground()
        apariencia.backgroundColor = .vino
        apariencia.titleTextAttributes = [.foregroundColor: UIColor.white]
        apariencia.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 32)
        ]
        navigationController?.navigationBar.standardAppearance = apariencia
        navigationController?.navigationBar.scrollEdgeAppearance = apariencia
        navigationController?.navigationBar.compactAppearance = apariencia
        navigationController?.navigationBar.tintColor = .white

        // El delegate de la tabla no está conectado en el storyboard; se asigna aquí para que se use heightForRowAt
        tableView.delegate = self

        view.backgroundColor = .crema
        tableView.backgroundColor = .crema
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return culturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let cultura = culturas[indexPath.row]

        var contenido = UIListContentConfiguration.subtitleCell()
        contenido.text = cultura.nombre
        contenido.textProperties.font = UIFont.boldSystemFont(ofSize: 18)
        contenido.textProperties.color = .marronOscuro
        contenido.secondaryText = cultura.region
        contenido.secondaryTextProperties.font = UIFont.systemFont(ofSize: 14)
        contenido.secondaryTextProperties.color = .terracota
        contenido.textToSecondaryTextVerticalPadding = 4
        contenido.image = fotoRedondeada(cultura.imagen, lado: 64, radio: 12)
        contenido.imageProperties.reservedLayoutSize = CGSize(width: 64, height: 64)
        contenido.imageToTextPadding = 14
        contenido.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 28, bottom: 16, trailing: 8)
        celda.contentConfiguration = contenido

        Estilo.aplicarTarjeta(a: celda)
        return celda
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let ancho = tableView.bounds.width
        let encabezado = UIView(frame: CGRect(x: 0, y: 0, width: ancho, height: 68))
        encabezado.backgroundColor = .crema

        let frase = UILabel(frame: CGRect(x: 20, y: 12, width: ancho - 40, height: 22))
        frase.text = "Descubre el legado de nuestros antepasados"
        frase.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        frase.textColor = .terracota
        frase.autoresizingMask = [.flexibleWidth]
        encabezado.addSubview(frase)

        let indicacion = UILabel(frame: CGRect(x: 20, y: 36, width: ancho - 40, height: 20))
        indicacion.text = "Toca una cultura para conocer su historia"
        indicacion.font = UIFont.systemFont(ofSize: 14)
        indicacion.textColor = .grisCalido
        indicacion.autoresizingMask = [.flexibleWidth]
        encabezado.addSubview(indicacion)

        return encabezado
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68
    }

    // Recorta la foto en un cuadrado (aspect fill, al centro) con esquinas redondeadas
    func fotoRedondeada(_ nombre: String, lado: CGFloat, radio: CGFloat) -> UIImage? {
        guard let foto = UIImage(named: nombre) else { return nil }
        let marco = CGRect(x: 0, y: 0, width: lado, height: lado)
        let escala = max(lado / foto.size.width, lado / foto.size.height)
        let ancho = foto.size.width * escala
        let alto = foto.size.height * escala
        let rect = CGRect(x: (lado - ancho) / 2, y: (lado - alto) / 2, width: ancho, height: alto)
        return UIGraphicsImageRenderer(size: marco.size).image { _ in
            UIBezierPath(roundedRect: marco, cornerRadius: radio).addClip()
            foto.draw(in: rect)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irMenu" {
            guard let tableView = view.subviews.compactMap({ $0 as? UITableView }).first,
                  let indexPath = tableView.indexPathForSelectedRow,
                  let destino = segue.destination as? MenuCulturaViewController else { return }
            destino.cultura = culturas[indexPath.row]
        }
    }
}
