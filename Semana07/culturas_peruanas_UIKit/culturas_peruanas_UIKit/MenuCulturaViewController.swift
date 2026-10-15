import UIKit

class MenuCulturaViewController: UIViewController {

    var cultura: Cultura?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = cultura?.nombre
    }

}
