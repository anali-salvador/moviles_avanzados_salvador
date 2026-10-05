import UIKit

// ===== CASO 1.5: HERENCIA Y POLIMORFISMO — LA CADENA DE SUCURSALES =====
// Docente: Juan León

enum CategoriaElectro {
    case lineaBlanca, tecnologia, pequenos
}

struct Electrodomestico {
    let nombre: String
    let marca: String
    let precioLista: Double
    let categoria: CategoriaElectro
}

class Sucursal {
    let nombre: String
    let ciudad: String

    init(nombre: String, ciudad: String) {
        self.nombre = nombre
        self.ciudad = ciudad
    }

    func descuento() -> Double {
        return 0.05
    }

    func costoEnvio(monto: Double) -> Double {
        return 30.0
    }

    func cotizar(item: Electrodomestico) {
        let precioConDescuento = item.precioLista * (1 - descuento())
        let envio = costoEnvio(monto: precioConDescuento)
        let total = precioConDescuento + envio
        print("\(nombre): \(item.nombre) -> S/ \(precioConDescuento) + envio S/ \(envio) = S/ \(total)")
    }
}

// TODO 14: SucursalLima — override descuento() -> 0.10; override costoEnvio(monto:): si monto >= 1500 devuelve 0.0, si no 30.0
class SucursalLima: Sucursal {
    override func descuento() -> Double {
        return 0.10
    }

    override func costoEnvio(monto: Double) -> Double {
        if monto >= 1500 {
            return 0.0
        } else {
            return 30.0
        }
    }
}

// TODO 15: SucursalProvincia — NO sobreescribe descuento (hereda 5%); override costoEnvio(monto:): 8% del monto, con mínimo de 50.0
class SucursalProvincia: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        let envioCalculado = monto * 0.08
        if envioCalculado < 50.0 {
            return 50.0
        } else {
            return envioCalculado
        }
    }
}

// TODO 16: SucursalOutlet — override descuento() -> 0.25; override costoEnvio(monto:) -> 0.0
class SucursalOutlet: Sucursal {
    override func descuento() -> Double {
        return 0.25
    }

    override func costoEnvio(monto: Double) -> Double {
        return 0.0
    }
}

// TODO 17: El recorrido polimorfico
let refrigeradora = Electrodomestico(nombre: "Refrigeradora", marca: "Frost", precioLista: 2000.0, categoria: .lineaBlanca)
let licuadora = Electrodomestico(nombre: "Licuadora", marca: "Mix", precioLista: 250.0, categoria: .pequenos)

let sucursales: [Sucursal] = [
    SucursalLima(nombre: "Lima Centro", ciudad: "Lima"),
    SucursalProvincia(nombre: "Provincia Cusco", ciudad: "Cusco"),
    SucursalOutlet(nombre: "Outlet Ate", ciudad: "Lima")
]

print("===== Refrigeradora (S/ 2000.0) =====")
for sucursal in sucursales {
    sucursal.cotizar(item: refrigeradora)
}

print("===== Licuadora (S/ 250.0) =====")
for sucursal in sucursales {
    sucursal.cotizar(item: licuadora)
}

// TODO 18: La prueba del polimorfismo
// SucursalOnline: envío fijo de 15.0, sin sobreescribir descuento (hereda 5%)
class SucursalOnline: Sucursal {
    override func costoEnvio(monto: Double) -> Double {
        return 15.0
    }
}
// Para agregar SucursalOnline al array y cotizar, solo se necesitaron 4 líneas nuevas:
// 1. La clase SucursalOnline (override de costoEnvio)
// 2-4. Si se agrega a la lista sucursales, no hace falta tocar ni cotizar() ni los for-in existentes.

// --- FIX: Este código tiene 2 errores ---
// Docente: Juan León
class SucursalMall: Sucursal {
    override func descuento() -> Double { // FIX 7: faltaba "override", porque este método ya existe en la clase base Sucursal y Swift exige marcar explícitamente que se está reescribiendo, para evitar errores accidentales
        return 0.12
    }
}

class SucursalExpress: Sucursal {
    let radioKm: Int

    init(nombre: String, ciudad: String, radioKm: Int) {
        self.radioKm = radioKm
        super.init(nombre: nombre, ciudad: ciudad) // FIX 8: faltaba llamar a super.init() con nombre y ciudad, porque la clase base necesita inicializar sus propias propiedades antes de que la subclase termine de inicializarse
    }
}

// --- PREDICT: Qué imprime? ---
// Docente: Juan León
let misteriosa: Sucursal = SucursalLima(nombre: "Lima Centro", ciudad: "Lima")
print(misteriosa.descuento()) // PREDICT 6: imprime 0.1, no 0.05. Aunque la variable es de tipo Sucursal, el objeto real en memoria es SucursalLima, y Swift decide en tiempo de ejecución cuál método usar según el tipo real del objeto (polimorfismo dinámico), no según el tipo declarado de la variable.

let monto = 2000.0 * (1 - misteriosa.descuento())
print(misteriosa.costoEnvio(monto: monto)) // PREDICT 7: monto = 2000 * (1 - 0.1) = 1800.0, que es mayor o igual a 1500, así que imprime 0.0 (envío gratis en Lima)
