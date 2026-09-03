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

// Función auxiliar para rellenar espacios y alinear texto en tarjetas
func rellenar(_ texto: String, longitud: Int) -> String {
    if texto.count >= longitud {
        return String(texto.prefix(longitud))
    }
    return texto + String(repeating: " ", count: longitud - texto.count)
}

let calendario = Calendar.current
let hoy = calendario.startOfDay(for: Date())

// ==========================================
// 1. ENCABEZADO Y CAPTURA DE DATOS
// ==========================================

print("\n====================================================")
print("      📚  SISTEMA DE PRÉSTAMO DE BIBLIOTECA  📚     ")
print("====================================================\n")

// --- VALIDAR LIBRO ---
print("📌 PASO 1: Datos del Libro y Usuario")
print("----------------------------------------------------")

var libro = ""
while true {
    libro = leerTexto(mensaje: "• Título del Libro :")
    
    if libro.isEmpty {
        print("   ❌ Error: El título no puede estar vacío. Intente de nuevo.\n")
    } else if Double(libro) != nil || !libro.contains(where: { $0.isLetter }) {
        print("   ❌ Error: El título debe contener texto. Intente de nuevo.\n")
    } else {
        break
    }
}

// --- VALIDAR TIPO DE USUARIO ---
var diasMaximos = 0
var multaBase = 0.0
var usuarioNormalizado = ""

while true {
    let usuarioInput = leerTexto(mensaje: "• Tipo de Usuario  (Alumno/Docente/Administrador/Coordinador):")
    
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
        print("   ❌ Error: Selección inválida. Solo: Alumno, Docente, Administrador o Coordinador.\n")
        continue
    }
    break
}

// --- VALIDAR FECHAS ---
print("\n📌 PASO 2: Fechas del Préstamo")
print("----------------------------------------------------")

var fechaPrestamo = Date()
var fechaPrestamoInicio = Date()

while true {
    let textoFechaPrestamo = leerTexto(mensaje: "• Fecha de Préstamo (dd/mm/yyyy):")
    
    guard let fechaConvertida = convertirAFecha(cadenaTexto: textoFechaPrestamo) else {
        print("   ❌ Error: Formato incorrecto. Use dd/mm/yyyy.\n")
        continue
    }
    
    let fechaInicioCalculada = calendario.startOfDay(for: fechaConvertida)
    
    if fechaInicioCalculada < hoy {
        print("   ❌ Error: La fecha de préstamo no puede ser anterior a hoy.\n")
    } else {
        fechaPrestamo = fechaConvertida
        fechaPrestamoInicio = fechaInicioCalculada
        break
    }
}

// Calcular Fecha Límite preliminar
let fechaLimite = calendario.date(byAdding: .day, value: diasMaximos, to: fechaPrestamo)!
let fechaLimiteInicio = calendario.startOfDay(for: fechaLimite)

let formateadorFecha = DateFormatter()
formateadorFecha.dateFormat = "dd/MM/yyyy"

print("• Devolución Programada : \(formateadorFecha.string(from: fechaLimite)) (\(diasMaximos) días asignados)")

var fechaDevolucion = Date()
var fechaDevolucionInicio = Date()

while true {
    let textoFechaDevolucion = leerTexto(mensaje: "• Devolución Real    (dd/mm/yyyy):")
    
    guard let fechaConvertida = convertirAFecha(cadenaTexto: textoFechaDevolucion) else {
        print("   ❌ Error: Formato incorrecto. Use dd/mm/yyyy.\n")
        continue
    }
    
    let fechaInicioCalculada = calendario.startOfDay(for: fechaConvertida)
    
    if fechaInicioCalculada < fechaPrestamoInicio {
        print("   ❌ Error: La devolución no puede ser anterior a la fecha de préstamo.\n")
    } else {
        fechaDevolucion = fechaConvertida
        fechaDevolucionInicio = fechaInicioCalculada
        break
    }
}

// ==========================================
// 2. CÁLCULO DE DÍAS DE ATRASO Y MULTA
// ==========================================

var diasAtraso = 0

if fechaDevolucionInicio > fechaLimiteInicio {
    let diferencia = calendario.dateComponents([.day], from: fechaLimiteInicio, to: fechaDevolucionInicio)
    diasAtraso = diferencia.day ?? 0
}

var multaTotal = 0.0

print("\n----------------------------------------------------")
print("📊 DESGLOSE DIARIO DE MULTAS")
print("----------------------------------------------------")

if diasAtraso > 0 {
    for dia in 1...diasAtraso {
        var porcentaje = 0.0
        var indicadorColor = ""
        
        if dia >= 1 && dia <= 3 {
            porcentaje = 0.00
            indicadorColor = "🟩 Sin multa        "
        } else if dia >= 4 && dia <= 6 {
            porcentaje = 0.25
            indicadorColor = "🟧 Multa baja (25%) "
        } else if dia >= 7 && dia <= 10 {
            porcentaje = 0.50
            indicadorColor = "🟥 Multa media (50%)"
        } else if dia >= 11 {
            porcentaje = 1.00
            indicadorColor = "🚨 Multa alta (100%)"
        }
        
        let multaDia = multaBase * porcentaje
        multaTotal += multaDia
        
        let diaFormateado = String(format: "%02d", dia)
        let textoMultaDia = String(format: "S/ %.2f", multaDia)
        let textoAcumulado = String(format: "S/ %.2f", multaTotal)
        
        print(" Día \(diaFormateado) | \(indicadorColor) | Tarifa: \(textoMultaDia) | Acumulado: \(textoAcumulado)")
    }
} else {
    print(" 🟢 Devolución realizada dentro del plazo. No se generaron multas.")
}

// ==========================================
// 3. ESTADO Y TARJETA FINAL DE RESULTADOS
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

let valLibro = rellenar(libro, longitud: 23)
let valUsuario = rellenar(usuarioNormalizado, longitud: 23)
let valDiasMax = rellenar("\(diasMaximos) días", longitud: 23)
let valFPrestamo = rellenar(formateadorFecha.string(from: fechaPrestamo), longitud: 23)
let valFLimite = rellenar(formateadorFecha.string(from: fechaLimite), longitud: 23)
let valFDevolucion = rellenar(formateadorFecha.string(from: fechaDevolucion), longitud: 23)
let valAtraso = rellenar("\(diasAtraso) día(s)", longitud: 23)
let valMulta = rellenar("S/ " + String(format: "%.2f", multaTotal), longitud: 23)
let valEstado = rellenar(estado, longitud: 23)
let valSituacion = rellenar(situacion, longitud: 21)

print("\n╔══════════════════════════════════════════════════╗")
print("║               RESUMEN DEL PRÉSTAMO               ║")
print("╠══════════════════════════════════════════════════╣")
print("║ 📖 Libro              : \(valLibro)║")
print("║ 👤 Usuario            : \(valUsuario)║")
print("║ ⏱️ Días Concedidos    : \(valDiasMax)║")
print("║ 📅 Fecha Préstamo     : \(valFPrestamo)║")
print("║ 🎯 Fecha Límite       : \(valFLimite)║")
print("║ 📥 Devolución Real    : \(valFDevolucion)║")
print("║ ⚠️ Días de Atraso     : \(valAtraso)║")
print("╠══════════════════════════════════════════════════╣")
print("║ 💰 MULTA TOTAL        : \(valMulta)║")
print("║ 📌 Estado             : \(valEstado)║")
print("║ 🚦 Situación          : \(valSituacion)║")
print("╚══════════════════════════════════════════════════╝\n")
