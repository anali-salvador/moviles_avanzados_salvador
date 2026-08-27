import Foundation

// MARK: - Función para calcular días otorgados según el tipo de usuario

func diasSegunTipo(tipo: String) -> Int {
    if tipo == "Alumno" {
        return 7
    } else if tipo == "Docente" {
        return 15
    } else if tipo == "Administrativo" {
        return 10
    } else {
        return 0
    }
}

// MARK: - Registro del préstamo

let tituloLibro = "Swift para principiantes"
let tipoUsuario = "Alumno"

let diasOtorgados = diasSegunTipo(tipo: tipoUsuario)

let fechaPrestamo = Date()
let calendario = Calendar.current
let fechaDevolucion = calendario.date(byAdding: .day, value: diasOtorgados, to: fechaPrestamo)!

// MARK: - Mostrar datos

let formato = DateFormatter()
formato.dateStyle = .medium

print("Título del libro: \(tituloLibro)")
print("Tipo de usuario: \(tipoUsuario)")
print("Días otorgados: \(diasOtorgados)")
print("Fecha de préstamo: \(formato.string(from: fechaPrestamo))")
print("Fecha de devolución: \(formato.string(from: fechaDevolucion))")
