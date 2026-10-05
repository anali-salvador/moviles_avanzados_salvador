import UIKit

class ViewControllerConfirmacion: UIViewController {
    // instanciar la clase ClienteModel
    var pCliente: ClienteModel = ClienteModel()

    // definir los controles
    @IBOutlet weak var tfApellido: UILabel!

    @IBOutlet weak var tfDNI: UILabel!
    @IBOutlet weak var tfNombre: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfApellido.text = pCliente.Apellido
        self.tfNombre.text = pCliente.Nombre
        self.tfDNI.text = pCliente.Dni
    }

    // MARK: - Botón Volver

    @IBAction func btnVolver(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    
}
