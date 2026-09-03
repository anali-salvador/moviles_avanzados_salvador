import Foundation

// ==========================================
// FUNCIONES AUXILIARES
// ==========================================

func leerTexto(mensaje: String) -> String {
    print(mensaje, terminator: " ")
    return readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
}

func convertirAFecha(cadenaTexto: String) -> Date? {
    let formateador = DateFormatter()
    formateador.dateFormat = "dd/MM/yyyy"
    formateador.locale = Locale(identifier: "es_PE")
    formateador.timeZone = TimeZone.current
    return formateador.date(from: cadenaTexto)
}

let calendario = Calendar.current
let hoy = calendario.startOfDay(for: Date())

print("==========================================")
print("     SISTEMA DE PRESTAMO BIBLIOTECA       ")
print("==========================================")

// ==========================================
// 1. INGRESO DE DATOS CON REPETICIÓN
// ==========================================

// --- VALIDAR LIBRO ---
var libro = ""
while true {
    libro = leerTexto(mensaje: "Ingrese el título del libro:")
    
    if libro.isEmpty {
        print("❌ Error: El título del libro no puede estar vacío. Intente de nuevo.\n")
    } else if Double(libro) != nil || !libro.contains(where: { $0.isLetter }) {
        print("❌ Error: El título no puede ser solo un número o caracteres especiales. Debe contener texto. Intente de nuevo.\n")
    } else {
        break // Dato válido, sale del bucle
    }
}

// --- VALIDAR TIPO DE USUARIO ---
var diasMaximos = 0
var multaBase = 0.0
var usuarioNormalizado = ""

while true {
    let usuarioInput = leerTexto(mensaje: "Ingrese el tipo de usuario (Alumno, Docente, Administrador, Coordinador):")
    
    switch usuarioInput.lowercased() {
    case "alumno":
        diasMaximos = 7
        multaBase = 1.50
        usuarioNormalizado = "Alumno"
    case "docente":
        diasMaximos = 15
        multaBase = 2.00
        usuarioNormalizado = "Docente"
    case "administrador":
        diasMaximos = 30
        multaBase = 3.00
        usuarioNormalizado = "Administrador"
    case "coordinador":
        diasMaximos = 15
        multaBase = 4.00
        usuarioNormalizado = "Coordinador"
    default:
        print("❌ Error: Tipo de usuario no válido. Solo seleccione: Alumno, Docente, Administrador o Coordinador.\n")
        continue // Solicita el ingreso nuevamente
    }
    
    break // Opción correcta
}

// --- VALIDAR FECHA DE PRÉSTAMO ---
var fechaPrestamo = Date()
var fechaPrestamoInicio = Date()

while true {
    let textoFechaPrestamo = leerTexto(mensaje: "Ingrese la fecha de préstamo (ej. 01/09/2026):")
    
    guard let fechaConvertida = convertirAFecha(cadenaTexto: textoFechaPrestamo) else {
        print("❌ Error: Formato de fecha incorrecto. Debe ser dd/MM/yyyy. Intente de nuevo.\n")
        continue
    }
    
    let fechaInicioCalculada = calendario.startOfDay(for: fechaConvertida)
    
    if fechaInicioCalculada < hoy {
        print("❌ Error: La fecha de préstamo (\(textoFechaPrestamo)) es del pasado. Ingrese una fecha igual o posterior a hoy.\n")
    } else {
        fechaPrestamo = fechaConvertida
        fechaPrestamoInicio = fechaInicioCalculada
        break
    }
}

// --- VALIDAR FECHA DE DEVOLUCIÓN ---
var fechaDevolucion = Date()
var fechaDevolucionInicio = Date()

while true {
    let textoFechaDevolucion = leerTexto(mensaje: "Ingrese la fecha de devolución real (ej. 25/09/2026):")
    
    guard let fechaConvertida = convertirAFecha(cadenaTexto: textoFechaDevolucion) else {
        print("❌ Error: Formato de fecha incorrecto. Debe ser dd/MM/yyyy. Intente de nuevo.\n")
        continue
    }
    
    let fechaInicioCalculada = calendario.startOfDay(for: fechaConvertida)
    
    if fechaInicioCalculada < fechaPrestamoInicio {
        print("❌ Error: La fecha de devolución no puede ser anterior a la fecha de préstamo. Intente de nuevo.\n")
    } else {
        fechaDevolucion = fechaConvertida
        fechaDevolucionInicio = fechaInicioCalculada
        break
    }
}

// ==========================================
// 2. CÁLCULO DE FECHA LÍMITE Y ATRASO
// ==========================================

let fechaLimite = calendario.date(
    byAdding: .day,
    value: diasMaximos,
    to: fechaPrestamo
)!

let fechaLimiteInicio = calendario.startOfDay(for: fechaLimite)

var diasAtraso = 0

if fechaDevolucionInicio > fechaLimiteInicio {
    let diferencia = calendario.dateComponents(
        [.day],
        from: fechaLimiteInicio,
        to: fechaDevolucionInicio
    )
    diasAtraso = diferencia.day ?? 0
}

// ==========================================
// 3. CÁLCULO DÍA A DÍA DE LA MULTA PROGRESIVA
// ==========================================

var multaTotal = 0.0

print("\n------------------------------------------")
print("        DESGLOSE DÍA POR DÍA             ")
print("------------------------------------------")

if diasAtraso > 0 {
    for dia in 1...diasAtraso {
        var porcentaje = 0.0
        
        if dia >= 1 && dia <= 3 {
            porcentaje = 0.00
        } else if dia >= 4 && dia <= 6 {
            porcentaje = 0.25
        } else if dia >= 7 && dia <= 10 {
            porcentaje = 0.50
        } else if dia >= 11 {
            porcentaje = 1.00
        }
        
        let multaDia = multaBase * porcentaje
        multaTotal += multaDia
        
        print("Día \(dia) | Multa diaria: S/ \(String(format: "%.2f", multaDia)) | Acumulado: S/ \(String(format: "%.2f", multaTotal))")
    }
} else {
    print("El libro fue devuelto a tiempo dentro del plazo permitido. Sin multas.")
}

// ==========================================
// 4. ESTADO Y SITUACIÓN
// ==========================================

var estado = ""
var situacion = ""

if diasAtraso == 0 {
    estado = "Devuelto a tiempo"
    situacion = "Usuario Habilitado"
} else {
    estado = "Devuelto con atraso"
    if diasAtraso >= 15 {
        situacion = "Usuario Suspendido"
    } else {
        situacion = "Usuario Habilitado"
    }
}

// ==========================================
// 5. RESUMEN FINAL
// ==========================================

let formateadorSalida = DateFormatter()
formateadorSalida.dateFormat = "dd/MM/yyyy"

print("\n==========================================")
print("            RESUMEN DEL PRÉSTAMO          ")
print("==========================================")
print("Libro:                 \(libro)")
print("Tipo de usuario:       \(usuarioNormalizado)")
print("Días de préstamo:      \(diasMaximos) días")
print("Fecha de préstamo:     \(formateadorSalida.string(from: fechaPrestamo))")
print("Fecha límite entrega:  \(formateadorSalida.string(from: fechaLimite))")
print("Fecha devolución real: \(formateadorSalida.string(from: fechaDevolucion))")
print("Días de atraso:        \(diasAtraso) día(s)")
print("Multa Total:           S/ \(String(format: "%.2f", multaTotal))")
print("Estado:                \(estado)")
print("Situación del Usuario: \(situacion)")
print("==========================================")
