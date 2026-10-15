import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Culturas"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return culturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let cultura = culturas[indexPath.row]
        celda.textLabel?.text = cultura.nombre
        celda.detailTextLabel?.text = cultura.region
        celda.imageView?.image = UIImage(named: cultura.imagen)
        return celda
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
