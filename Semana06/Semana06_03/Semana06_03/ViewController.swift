//
//  ViewController.swift
//  Semana06_03
//
//  Created by Tecsup on 5/10/26.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Conexiones de los TextField

    @IBOutlet weak var tfElectrodomestico: UITextField!
    @IBOutlet weak var tfPrecioUnitario: UITextField!
    @IBOutlet weak var tfCantidad: UITextField!
    @IBOutlet weak var tfMeses: UITextField!
    @IBOutlet weak var tfTasaInteres: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // tocar fuera de los campos oculta el teclado (decimalPad y numberPad no tienen tecla Return)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    // convierte el texto a Double aceptando coma o punto; si es vacío o inválido devuelve 0
    func leerNumero(_ campo: UITextField) -> Double {
        let texto = (campo.text ?? "")
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: ",", with: ".")
        return Double(texto) ?? 0
    }

    // MARK: - Navegación

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showResultado",
              let oPantalla2 = segue.destination as? ResultadoViewController else { return }

        let precioUnitario = leerNumero(self.tfPrecioUnitario)
        let cantidad = leerNumero(self.tfCantidad)
        let meses = leerNumero(self.tfMeses)
        let tasaInteresMensual = leerNumero(self.tfTasaInteres)

        let subtotal = precioUnitario * cantidad
        let igv = subtotal * 0.18
        let base = subtotal + igv
        let intereses = base * (tasaInteresMensual / 100) * meses
        let total = base + intereses
        // evita dividir entre 0 si Meses está vacío o es 0
        let cuota = meses > 0 ? total / meses : 0

        let oVenta: VentaModel = VentaModel(
            subtotal: subtotal,
            igv: igv,
            base: base,
            intereses: intereses,
            total: total,
            cuota: cuota
        )

        oPantalla2.pVenta = oVenta
    }
}
