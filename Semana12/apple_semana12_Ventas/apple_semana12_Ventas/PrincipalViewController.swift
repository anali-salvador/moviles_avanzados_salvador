import UIKit

/// Contenedor principal: pestañas según el rol del usuario de la sesión.
class PrincipalViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let esSupervisor = Sesion.shared.usuarioActual?.rol == "Supervisor"
        Tema.estilizar(tabBar)

        if esSupervisor {
            viewControllers = [
                pestana(ResumenViewController(), "Resumen", "chart.bar.fill"),
                pestana(VentasEquipoViewController(), "Ventas", "list.bullet.rectangle.fill"),
                pestana(productos(), "Productos", "shippingbox.fill"),
                pestana(ClientesViewController(style: .insetGrouped), "Clientes", "person.2.fill"),
                pestana(CuentaViewController(), "Cuenta", "person.crop.circle.fill")
            ]
        } else {
            viewControllers = [
                pestana(productos(), "Productos", "shippingbox.fill"),
                pestana(ClientesViewController(style: .insetGrouped), "Clientes", "person.2.fill"),
                pestana(NuevaVentaViewController(), "Venta", "cart.fill.badge.plus"),
                pestana(MisVentasViewController(), "Mis ventas", "list.bullet.rectangle.fill"),
                pestana(CuentaViewController(), "Cuenta", "person.crop.circle.fill")
            ]
        }
    }

    private func productos() -> UIViewController {
        ProductosViewController(style: .insetGrouped)
    }

    private func pestana(_ controlador: UIViewController, _ titulo: String, _ icono: String) -> UINavigationController {
        controlador.title = titulo
        let nav = UINavigationController(rootViewController: controlador)
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), selectedImage: nil)
        return nav
    }
}
