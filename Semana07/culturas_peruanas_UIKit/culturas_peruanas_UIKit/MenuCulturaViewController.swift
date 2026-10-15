import UIKit

class MenuCulturaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var cultura: Cultura?
    let opciones = ["Nombre", "Región", "Descripción", "Imagen"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = cultura?.nombre
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opciones.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "opcion", for: indexPath)
        celda.textLabel?.text = opciones[indexPath.row]
        return celda
    }

}
