import Foundation

// MARK: - Funciones

func diasSegunTipo(tipo: Int) -> Int {
    if tipo == 1 {
        return 7
    } else if tipo == 2 {
        return 15
    } else if tipo == 3 {
        return 10
    } else {
        return 0
    }
}

func nombreTipo(tipo: Int) -> String {
    if tipo == 1 {
        return "Alumno"
    } else if tipo == 2 {
        return "Docente"
    } else if tipo == 3 {
        return "Administrativo"
    } else {
        return "Desconocido"
    }
}

func multaBaseSegunTipo(tipo: Int) -> Double {
    if tipo == 1 {
        return 1.50
    } else if tipo == 2 {
        return 2.00
    } else if tipo == 3 {
        return 3.00
    } else {
        return 0.0
    }
}

func calcularMultaTotal(diasAtraso: Int, multaBase: Double) -> Double {
    var multaTotal = 0.0
    if diasAtraso <= 0 {
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

// MARK: - Formato de fecha

let formato = DateFormatter()
formato.dateFormat = "dd/MM/yyyy"

// MARK: - Ingreso de datos (todo por teclado)

print("=== SISTEMA DE PRESTAMO DE LIBROS ===")

print("Titulo del libro:")
let tituloLibro = readLine() ?? ""

print("Seleccione tipo de usuario:")
print("1. Alumno")
print("2. Docente")
print("3. Administrativo")
let tipoUsuario = Int(readLine() ?? "") ?? 0

print("Fecha de prestamo (dd/MM/yyyy):")
let textoFechaPrestamo = readLine() ?? ""
let fechaPrestamo = formato.date(from: textoFechaPrestamo) ?? Date()

print("Fecha de devolucion (dd/MM/yyyy):")
let textoFechaDevolucion = readLine() ?? ""
let fechaDevolucionReal = formato.date(from: textoFechaDevolucion) ?? Date()

let diasOtorgados = diasSegunTipo(tipo: tipoUsuario)
let multaBase = multaBaseSegunTipo(tipo: tipoUsuario)

let calendario = Calendar.current
let fechaLimite = calendario.date(byAdding: .day, value: diasOtorgados, to: fechaPrestamo)!

// MARK: - Calcular dias de atraso

let componentes = calendario.dateComponents([.day], from: fechaLimite, to: fechaDevolucionReal)
var diasAtraso = componentes.day ?? 0
if diasAtraso < 0 {
    diasAtraso = 0
}

let multaTotal = calcularMultaTotal(diasAtraso: diasAtraso, multaBase: multaBase)

// MARK: - Estado y situacion

var estado = "Devuelto a tiempo"
if diasAtraso > 0 {
    estado = "Devuelto con atraso"
}

var usuarioHabilitado = "Si"
var situacion = "Usuario habilitado"
if diasAtraso >= 10 {
    usuarioHabilitado = "No"
    situacion = "Usuario suspendido"
}

// MARK: - Mostrar resultado

print("")
print("=== RESUMEN DEL PRESTAMO ===")
print("Libro: \(tituloLibro)")
print("Tipo de usuario: \(nombreTipo(tipo: tipoUsuario))")
print("Fecha de prestamo: \(formato.string(from: fechaPrestamo))")
print("Fecha limite: \(formato.string(from: fechaLimite))")
print("Fecha de devolucion: \(formato.string(from: fechaDevolucionReal))")
print("Dias de atraso: \(diasAtraso)")
print("Multa total: S/ \(multaTotal)")
print("Estado: \(estado)")
print("Situacion: \(situacion)")
print("Usuario habilitado: \(usuarioHabilitado)")
