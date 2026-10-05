//
//  ViewController.swift
//  apple_lab05_IMC
//
//  Created by Tecsup on 5/10/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func calcularResultado(_ sender: UIButton) {
        view.endEditing(true)

        guard let peso = numero(de: weightTextField),
              let altura = numero(de: heightTextField),
              peso > 0, altura > 0 else {
            resultLabel.text = "Por favor, ingresa valores válidos."
            return
        }

        let imc = peso / (altura * altura)

        let estado: String
        if imc < 18.5 {
            estado = "Bajo peso"
        } else if imc < 25 {
            estado = "Peso normal"
        } else if imc < 30 {
            estado = "Sobrepeso"
        } else {
            estado = "Obesidad"
        }

        resultLabel.text = String(format: "IMC: %.2f - %@", imc, estado)
    }

    // Convierte el texto del campo a Double; acepta coma o punto decimal.
    private func numero(de textField: UITextField) -> Double? {
        let texto = (textField.text ?? "")
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: ",", with: ".")
        return Double(texto)
    }

}

