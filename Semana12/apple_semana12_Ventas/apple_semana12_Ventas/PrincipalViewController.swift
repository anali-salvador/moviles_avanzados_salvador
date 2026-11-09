import UIKit

/// Contenedor principal: pestañas según el rol del usuario de la sesión.
class PrincipalViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let esSupervisor = Sesion.shared.usuarioActual?.rol == "Supervisor"

        if esSupervisor {
            viewControllers = [
                pestana(ProvisionalViewController(titulo: "Resumen"), "Resumen", "chart.bar"),
                pestana(ProvisionalViewController(titulo: "Ventas"), "Ventas", "list.bullet.rectangle"),
                pestana(productos(), "Productos", "shippingbox"),
                pestana(ClientesViewController(style: .insetGrouped), "Clientes", "person.2"),
                pestana(CuentaViewController(), "Cuenta", "person.crop.circle")
            ]
        } else {
            viewControllers = [
                pestana(productos(), "Productos", "shippingbox"),
                pestana(ClientesViewController(style: .insetGrouped), "Clientes", "person.2"),
                pestana(NuevaVentaViewController(), "Venta", "cart.badge.plus"),
                pestana(ProvisionalViewController(titulo: "Mis ventas"), "Mis ventas", "list.bullet.rectangle"),
                pestana(CuentaViewController(), "Cuenta", "person.crop.circle")
            ]
        }
    }

    private func productos() -> UIViewController {
        ProductosViewController(style: .insetGrouped)
    }

    private func pestana(_ controlador: UIViewController, _ titulo: String, _ icono: String) -> UINavigationController {
        controlador.title = titulo
        let nav = UINavigationController(rootViewController: controlador)
        nav.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), selectedImage: nil)
        return nav
    }
}
