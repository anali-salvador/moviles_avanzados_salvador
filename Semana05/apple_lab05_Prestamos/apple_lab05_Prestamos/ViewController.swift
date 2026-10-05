//
//  ViewController.swift
//  apple_lab05_Prestamos
//
//  Created by Tecsup on 5/10/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var capitalTextField: UITextField!
    @IBOutlet weak var tasaTextField: UITextField!
    @IBOutlet weak var plazoTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func calcularPrestamo(_ sender: UIButton) {
        view.endEditing(true)

        // La tasa puede ser 0 % (préstamo sin interés); capital y plazo deben ser mayores que cero.
        guard let capital = numero(de: capitalTextField),
              let tasa = numero(de: tasaTextField),
              let anios = numero(de: plazoTextField),
              capital > 0, tasa >= 0, anios > 0 else {
            resultLabel.text = "Por favor, ingresa valores válidos."
            return
        }

        let r = (tasa / 100) / 12
        let n = anios * 12

        let cuota: Double
        if r == 0 {
            cuota = capital / n
        } else {
            cuota = capital * (r * pow(1 + r, n)) / (pow(1 + r, n) - 1)
        }
        let total = cuota * n

        resultLabel.text = String(format: "Cuota mensual: S/ %.2f\nTotal a pagar: S/ %.2f", cuota, total)
    }

    // Convierte el texto del campo a Double; acepta coma o punto decimal.
    private func numero(de textField: UITextField) -> Double? {
        let texto = (textField.text ?? "")
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: ",", with: ".")
        return Double(texto)
    }

}

