import Foundation

// ==========================================
// FUNCIONES AUXILIARES DE ENTRADA Y FORMATO
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

func rellenar(_ texto: String, longitud: Int) -> String {
    if texto.count >= longitud {
        return String(texto.prefix(longitud))
    }
    return texto + String(repeating: " ", count: longitud - texto.count)
}

let calendario = Calendar.current
let hoy = calendario.startOfDay(for: Date())

// ==========================================
// 1. INGRESO DE DATOS
// ==========================================

print("\n====================================================")
print("      📚  SISTEMA DE PRÉSTAMO DE BIBLIOTECA  📚     ")
print("====================================================\n")

print("📌 PASO 1: Datos Generales")
print("----------------------------------------------------")

var libro = ""
while true {
    libro = leerTexto(mensaje: "• Ingrese el título del libro:")
    if libro.isEmpty {
        print("   ❌ Error: El título no puede estar vacío.\n")
    } else if Double(libro) != nil || !libro.contains(where: { $0.isLetter }) {
        print("   ❌ Error: El título no puede ser solo números o caracteres especiales.\n")
    } else {
        break
    }
}

var diasMaximos = 0
var tarifaBase = 0.0
var usuarioNormalizado = ""

while true {
    let usuarioInput = leerTexto(mensaje: "• Ingrese el tipo de usuario (Alumno, Docente, Administrador, Coordinador):")
    
    switch usuarioInput.lowercased() {
    case "alumno":
        diasMaximos = 7
        tarifaBase = 1.50
        usuarioNormalizado = "Alumno"
    case "docente":
        diasMaximos = 15
        tarifaBase = 2.00
        usuarioNormalizado = "Docente"
    case "administrador":
        diasMaximos = 30
        tarifaBase = 3.00
        usuarioNormalizado = "Administrador"
    case "coordinador":
        diasMaximos = 15
        tarifaBase = 4.00
        usuarioNormalizado = "Coordinador"
    default:
        print("   ❌ Error: Seleccione: Alumno, Docente, Administrador o Coordinador.\n")
        continue
    }
    break
}

print("\n📌 PASO 2: Fechas del Préstamo")
print("----------------------------------------------------")

var fechaPrestamo = Date()
var fechaPrestamoInicio = Date()

while true {
    let textoFechaPrestamo = leerTexto(mensaje: "• Ingrese la fecha de préstamo (ej. 01/09/2026):")
    guard let fechaConvertida = convertirAFecha(cadenaTexto: textoFechaPrestamo) else {
        print("   ❌ Error: Formato incorrecto. Debe ser dd/MM/yyyy.\n")
        continue
    }
    let fechaInicioCalculada = calendario.startOfDay(for: fechaConvertida)
    if fechaInicioCalculada < hoy {
        print("   ❌ Error: La fecha es del pasado. Ingrese una fecha igual o posterior a hoy.\n")
    } else {
        fechaPrestamo = fechaConvertida
        fechaPrestamoInicio = fechaInicioCalculada
        break
    }
}

var fechaDevolucion = Date()
var fechaDevolucionInicio = Date()

while true {
    let textoFechaDevolucion = leerTexto(mensaje: "• Ingrese la fecha de devolución real (ej. 25/09/2026):")
    guard let fechaConvertida = convertirAFecha(cadenaTexto: textoFechaDevolucion) else {
        print("   ❌ Error: Formato incorrecto. Debe ser dd/MM/yyyy.\n")
        continue
    }
    let fechaInicioCalculada = calendario.startOfDay(for: fechaConvertida)
    if fechaInicioCalculada < fechaPrestamoInicio {
        print("   ❌ Error: La fecha de devolución no puede ser anterior a la de préstamo.\n")
    } else {
        fechaDevolucion = fechaConvertida
        fechaDevolucionInicio = fechaInicioCalculada
        break
    }
}

// ==========================================
// 2. CÁLCULO DE ATRASO
// ==========================================

let fechaLimite = calendario.date(byAdding: .day, value: diasMaximos, to: fechaPrestamo)!
let fechaLimiteInicio = calendario.startOfDay(for: fechaLimite)

var diasAtraso = 0
if fechaDevolucionInicio > fechaLimiteInicio {
    let diferencia = calendario.dateComponents([.day], from: fechaLimiteInicio, to: fechaDevolucionInicio)
    diasAtraso = diferencia.day ?? 0
}

// ==========================================
// 3. CALENDARIO DE MULTAS Y MULTA FINAL
// ==========================================

var multaTotal = 0.0

print("\n====================================================")
print("             === CALENDARIO DE MULTAS ===")
print("====================================================")

if diasAtraso > 0 {
    for dia in 1...diasAtraso {
        var porcentajeRecargo = 0.0
        var multaDia = 0.0
        
        if dia >= 1 && dia <= 3 {
            porcentajeRecargo = 0.00
            multaDia = 0.00
        } else if dia >= 4 && dia <= 6 {
            porcentajeRecargo = 0.25
            multaDia = tarifaBase * (1.0 + porcentajeRecargo) // 4.00 + 25% = 5.00
        } else if dia >= 7 && dia <= 10 {
            porcentajeRecargo = 0.50
            multaDia = tarifaBase * (1.0 + porcentajeRecargo) // 4.00 + 50% = 6.00
        } else if dia >= 11 {
            porcentajeRecargo = 1.00
            multaDia = tarifaBase * (1.0 + porcentajeRecargo) // 4.00 + 100% = 8.00
        }
        
        // La multa total del préstamo se define por el tramo del último día devuelto
        multaTotal = multaDia
        
        let fechaDia = calendario.date(byAdding: .day, value: dia, to: fechaLimite)!
        let formateadorFecha = DateFormatter()
        formateadorFecha.dateFormat = "dd/MM/yyyy"
        let strFechaDia = formateadorFecha.string(from: fechaDia)
        
        let strPorcentaje = String(format: "%.0f%%", porcentajeRecargo * 100)
        let strPorcentajeConSigno = porcentajeRecargo > 0 ? "+\(strPorcentaje)" : strPorcentaje
        let textoMultaDia = String(format: "S/ %.2f", multaDia)
        
        print("Dia \(dia) | \(strFechaDia) | \(rellenar(strPorcentajeConSigno, longitud: 5)) | \(textoMultaDia)")
    }
} else {
    print("🟢 El libro fue devuelto a tiempo dentro del plazo permitido. Sin multas.")
}

// ==========================================
// 4. ESTADO Y SITUACIÓN
// ==========================================

var estado = ""
var situacion = ""

if diasAtraso == 0 {
    estado = "Devuelto a tiempo"
    situacion = "🟢 Usuario Habilitado"
} else {
    estado = "Devuelto con atraso"
    if diasAtraso >= 15 {
        situacion = "🔴 Usuario Suspendido"
    } else {
        situacion = "🟢 Usuario Habilitado"
    }
}

// ==========================================
// 5. RESUMEN FINAL
// ==========================================

let formateadorSalida = DateFormatter()
formateadorSalida.dateFormat = "dd/MM/yyyy"

let valLibro = rellenar(libro, longitud: 23)
let valUsuario = rellenar(usuarioNormalizado, longitud: 23)
let valDiasMax = rellenar("\(diasMaximos) días", longitud: 23)
let valFPrestamo = rellenar(formateadorSalida.string(from: fechaPrestamo), longitud: 23)
let valFLimite = rellenar(formateadorSalida.string(from: fechaLimite), longitud: 23)
let valFDevolucion = rellenar(formateadorSalida.string(from: fechaDevolucion), longitud: 23)
let valAtraso = rellenar("\(diasAtraso) día(s)", longitud: 23)
let valMulta = rellenar("S/ " + String(format: "%.2f", multaTotal), longitud: 23)
let valEstado = rellenar(estado, longitud: 23)
let valSituacion = rellenar(situacion, longitud: 21)

print("\n╔══════════════════════════════════════════════════╗")
print("║               RESUMEN DEL PRÉSTAMO               ║")
print("╠══════════════════════════════════════════════════╣")
print("║ 📖 Libro              : \(valLibro)║")
print("║ 👤 Tipo de usuario    : \(valUsuario)║")
print("║ ⏱️ Días de préstamo   : \(valDiasMax)║")
print("║ 📅 Fecha de préstamo  : \(valFPrestamo)║")
print("║ 🎯 Fecha límite       : \(valFLimite)║")
print("║ 📥 Devolución real    : \(valFDevolucion)║")
print("║ ⚠️ Días de atraso     : \(valAtraso)║")
print("╠══════════════════════════════════════════════════╣")
print("║ 💰 Multa Total        : \(valMulta)║")
print("║ 📌 Estado             : \(valEstado)║")
print("║ 🚦 Situación Usuario  : \(valSituacion)║")
print("╚══════════════════════════════════════════════════╝\n")
