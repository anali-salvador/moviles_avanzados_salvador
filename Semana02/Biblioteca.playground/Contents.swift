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

// MARK: - Función para obtener la multa base según el tipo de usuario

func multaBaseSegunTipo(tipo: String) -> Double {
    if tipo == "Alumno" {
        return 1.50
    } else if tipo == "Docente" {
        return 2.00
    } else if tipo == "Administrativo" {
        return 3.00
    } else {
        return 0.0
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

// MARK: - Función para calcular la multa progresiva (día por día)

func calcularMultaTotal(diasAtraso: Int, multaBase: Double) -> Double {
    var multaTotal = 0.0
    
    if diasAtraso == 0 {
        return 0.0
    }
    
    var dia = 1
    while dia <= diasAtraso {
        var multaDelDia = multaBase
        
        if dia >= 4 && dia <= 6 {
            multaDelDia = multaBase * 1.5
        } else if dia >= 7 {
            multaDelDia = multaBase * 2.0
        }
        
        multaTotal = multaTotal + multaDelDia
        dia = dia + 1
    }
    
    return multaTotal
}

// MARK: - Registro del préstamo

let tituloLibro = "Swift para principiantes"
let tipoUsuario = "Alumno"

let diasOtorgados = diasSegunTipo(tipo: tipoUsuario)
let multaBase = multaBaseSegunTipo(tipo: tipoUsuario)

let fechaPrestamo = Date()
let calendario = Calendar.current
let fechaLimite = calendario.date(byAdding: .day, value: diasOtorgados, to: fechaPrestamo)!

// MARK: - Devolución del libro (simulada con 4 días después de la fecha límite, para probar)

let fechaDevolucion = calendario.date(byAdding: .day, value: 4, to: fechaLimite)!

let atraso = diasDeAtraso(fechaLimite: fechaLimite, fechaDevolucion: fechaDevolucion)
let multaTotal = calcularMultaTotal(diasAtraso: atraso, multaBase: multaBase)

// MARK: - Estado, situación y suspensión

var estado = "Devuelto a tiempo"
if atraso > 0 {
    estado = "Devuelto con atraso"
}

var usuarioHabilitado = true
var situacion = "Usuario habilitado"
if atraso >= 10 {
    usuarioHabilitado = false
    situacion = "Usuario suspendido para nuevos prestamos"
}

// MARK: - Mostrar datos

let formato = DateFormatter()
formato.dateStyle = .medium

print("Título del libro: \(tituloLibro)")
print("Tipo de usuario: \(tipoUsuario)")
print("Días otorgados: \(diasOtorgados)")
print("Fecha de préstamo: \(formato.string(from: fechaPrestamo))")
print("Fecha límite: \(formato.string(from: fechaLimite))")
print("Fecha de devolución: \(formato.string(from: fechaDevolucion))")
print("Días de atraso: \(atraso)")
print("Multa total: S/ \(multaTotal)")
print("Estado: \(estado)")
print("Situación: \(situacion)")
print("Usuario habilitado: \(usuarioHabilitado)")
