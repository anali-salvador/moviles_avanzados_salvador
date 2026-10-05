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

// ===== CASO 2 — PARTE A: BIBLIOTECA (SIN IA) =====
// Docente: Juan León

enum EstadoLibro { // Los dos estados posibles de un libro
    case disponible, prestado // disponible: se puede prestar; prestado: alguien lo tiene
}

struct Libro { // Modelo de datos de un libro (tipo por valor)
    let titulo: String // Título del libro, no cambia
    let autor: String // Autor del libro, no cambia
    var estado: EstadoLibro = .disponible // Estado actual; var porque cambia al prestar/devolver. Por defecto disponible
}

class Biblioteca { // Gestiona la colección de libros y sus operaciones
    var libros: [Libro] = [] // Lista de libros registrados, empieza vacía

    func agregar(libro: Libro) { // Registra un libro nuevo en la biblioteca
        libros.append(libro) // Lo añade al final del array
    }

    func prestar(titulo: String) -> Bool { // Intenta prestar un libro; devuelve true si se pudo
        for i in 0..<libros.count { // Recorre por índice para poder modificar el struct dentro del array
            if libros[i].titulo == titulo { // Encontró el libro buscado
                if libros[i].estado == .disponible { // Solo se presta si está disponible
                    libros[i].estado = .prestado // Cambia el estado directamente en el array
                    print("Préstamo aprobado: \(titulo)") // Informa el éxito
                    return true // Préstamo realizado
                } else { // El libro existe pero ya está prestado
                    print("Error: \(titulo) ya está prestado") // Informa el motivo del rechazo
                    return false // Préstamo rechazado
                }
            }
        }
        print("Error: no existe \(titulo)") // Terminó el recorrido sin encontrar el título
        return false // No se pudo prestar porque el libro no existe
    }

    func devolver(titulo: String) -> Bool { // Intenta devolver un libro; devuelve true si se pudo
        for i in 0..<libros.count { // Recorre por índice para poder modificar el struct dentro del array
            if libros[i].titulo == titulo { // Encontró el libro buscado
                if libros[i].estado == .prestado { // Solo se devuelve si estaba prestado
                    libros[i].estado = .disponible // Vuelve a quedar disponible
                    print("Devolución registrada: \(titulo)") // Informa el éxito
                    return true // Devolución realizada
                } else { // El libro existe pero no estaba prestado
                    print("Error: \(titulo) no estaba prestado") // Informa el motivo del rechazo
                    return false // Devolución rechazada
                }
            }
        }
        print("Error: no existe \(titulo)") // Terminó el recorrido sin encontrar el título
        return false // No se pudo devolver porque el libro no existe
    }

    func inventario() { // Muestra todos los libros con su estado actual
        print("===== INVENTARIO =====") // Encabezado del reporte
        for libro in libros { // Recorre cada libro (solo lectura, no hace falta índice)
            switch libro.estado { // switch exhaustivo sobre el enum: cubre todos los casos
            case .disponible: // Caso libro disponible
                print("\(libro.titulo) (\(libro.autor)) - disponible") // Imprime título, autor y estado
            case .prestado: // Caso libro prestado
                print("\(libro.titulo) (\(libro.autor)) - prestado") // Imprime título, autor y estado
            }
        }
    }
}

// Simulación
let biblioteca = Biblioteca() // Crea la biblioteca vacía
biblioteca.agregar(libro: Libro(titulo: "Cien años de soledad", autor: "Gabriel García Márquez")) // Registra el libro 1 (disponible por defecto)
biblioteca.agregar(libro: Libro(titulo: "La ciudad y los perros", autor: "Mario Vargas Llosa")) // Registra el libro 2
biblioteca.agregar(libro: Libro(titulo: "El Quijote", autor: "Miguel de Cervantes")) // Registra el libro 3

_ = biblioteca.prestar(titulo: "La ciudad y los perros") // Primer préstamo: se aprueba
_ = biblioteca.prestar(titulo: "La ciudad y los perros") // Segundo préstamo del mismo libro: error, ya está prestado
_ = biblioteca.devolver(titulo: "La ciudad y los perros") // Se devuelve: vuelve a estar disponible
_ = biblioteca.prestar(titulo: "El Quijote") // Préstamo aprobado de El Quijote
_ = biblioteca.prestar(titulo: "El Principito") // Error: el libro no existe en la biblioteca
biblioteca.inventario() // Muestra el estado final de todos los libros
