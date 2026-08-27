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

// MARK: - Función para calcular días de atraso

func diasDeAtraso(fechaLimite: Date, fechaDevolucion: Date) -> Int {
    let calendario = Calendar.current
    let componentes = calendario.dateComponents([.day], from: fechaLimite, to: fechaDevolucion)
    let dias = componentes.day ?? 0
    if dias > 0 {
        return dias
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
let fechaLimite = calendario.date(byAdding: .day, value: diasOtorgados, to: fechaPrestamo)!

// MARK: - Devolución del libro (simulada con 4 días después de la fecha límite, para probar)

let fechaDevolucion = calendario.date(byAdding: .day, value: 4, to: fechaLimite)!

let atraso = diasDeAtraso(fechaLimite: fechaLimite, fechaDevolucion: fechaDevolucion)

// MARK: - Mostrar datos

let formato = DateFormatter()
formato.dateStyle = .medium

print("Título del libro: \(tituloLibro)")
print("Tipo de usuario: \(tipoUsuario)")
print("Días otorgados: \(diasOtorgados)")
print("Fecha de préstamo: \(formato.string(from: fechaPrestamo))")
print("Fecha límite: \(formato.string(from: fechaLimite))")
print("Fecha de devolución: \(formato.string(from: fechaDevolucion))")

if atraso > 0 {
    print("Días de atraso: \(atraso)")
} else {
    print("Devuelto a tiempo, sin atraso")
}
