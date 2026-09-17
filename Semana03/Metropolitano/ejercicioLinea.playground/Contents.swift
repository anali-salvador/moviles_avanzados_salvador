import Foundation

// ============================================================
// DATOS BASE
// ============================================================

struct LineaInfo {
    let estado: String
    let estaciones: [String]
    let estacionesOperativas: [String]?
}

nonisolated(unsafe) var LINEAS: [String: LineaInfo] = [
    "Línea 1": LineaInfo(
        estado: "operativa",
        estaciones: [
            "Villa El Salvador", "Parque Industrial", "Pumacahua", "Villa María",
            "María Auxiliadora", "San Juan", "Atocongo", "Jorge Chávez",
            "Ayacucho", "Cabitos", "Angamos", "San Borja Sur", "La Cultura",
            "Nicolás Arriola", "Gamarra", "Miguel Grau", "El Ángel",
            "Presbítero Maestro", "Caja de Agua", "Pirámide del Sol",
            "Los Jardines", "Los Postes", "San Carlos", "San Martín",
            "Santa Rosa", "Bayóvar",
        ],
        estacionesOperativas: nil
    ),
    "Línea 2": LineaInfo(
        estado: "construcción",
        estaciones: [
            "Puerto del Callao", "Buenos Aires", "Juan Pablo II", "Insurgentes",
            "Carmen de la Legua", "Óscar R. Benavides", "San Marcos", "Elio",
            "La Alborada", "Tingo María", "Parque Murillo", "Plaza Bolognesi",
            "Estación Central", "Plaza Manco Cápac", "Cangallo", "28 de Julio",
            "Nicolás Ayllón", "Circunvalación", "San Juan de Dios",
            "Evitamiento", "Óvalo Santa Anita", "Colectora Industrial",
            "Hermilio Valdizán", "Mercado Santa Anita", "Vista Alegre",
            "Prolongación Javier Prado", "Municipalidad de Ate",
        ],
        estacionesOperativas: [
            "Evitamiento", "Óvalo Santa Anita", "Colectora Industrial",
            "Hermilio Valdizán", "Mercado Santa Anita",
        ]
    ),
    "Línea 3": LineaInfo(
        estado: "proyecto",
        estaciones: [
            "El Álamo", "Huandoy", "2 de Octubre", "Villa Sol", "Naranjal",
            "Carlos Izaguirre", "Tomás Valle", "Bartolomé de las Casas",
            "José Granda", "Caquetá", "Tacna", "Garcilaso de la Vega",
            "Estación Central", "Parque de la Reserva",
            "Museo de Historia Natural", "César Canevaro",
            "Conde de San Isidro", "Andrés Aramburú", "Huaca Pucllana",
            "Parque Central de Miraflores", "Parque Reducto",
            "República de Panamá", "Juana Alarco", "Cabitos",
            "Alejandro Velasco", "Las Gardenias", "Los Héroes", "Pedro Miotta",
        ],
        estacionesOperativas: []
    ),
    "Línea 4": LineaInfo(
        estado: "construcción",
        estaciones: [
            "Gambetta", "Canta Callao", "Bocanegra", "Aeropuerto", "El Olivar",
            "Quilca", "Morales Duárez", "Carmen de la Legua", "Venezuela",
            "Rafael Escardó", "Pando", "José de Sucre", "Brasil",
            "Felipe Salaverry", "Guillermo Prescott", "Las Palmeras",
            "Conde de San Isidro", "Rivera Navarrete", "Pablo Carriquiry",
            "La Cultura", "San Luis", "Monterrico", "Manuel Olguín",
            "Los Frutales", "La Molina", "Santa Patricia", "Mayorazgo",
            "Mercado Santa Anita",
        ],
        estacionesOperativas: []
    ),
]

let DISTRITOS: [String: String] = [
    "Villa El Salvador": "Villa El Salvador", "Parque Industrial": "Villa El Salvador",
    "Pumacahua": "Villa El Salvador",
    "Villa María": "Villa María del Triunfo", "María Auxiliadora": "Villa María del Triunfo",
    "San Juan": "San Juan de Miraflores",
    "Jorge Chávez": "Santiago de Surco", "Ayacucho": "Santiago de Surco",
    "Angamos": "Santiago de Surco",
    "San Borja Sur": "San Borja", "Nicolás Arriola": "La Victoria",
    "Miguel Grau": "Cercado de Lima",
    "El Ángel": "El Agustino",
    "Caja de Agua": "San Juan de Lurigancho", "Pirámide del Sol": "San Juan de Lurigancho",
    "Los Jardines": "San Juan de Lurigancho", "Los Postes": "San Juan de Lurigancho",
    "San Carlos": "San Juan de Lurigancho", "San Martín": "San Juan de Lurigancho",
    "Santa Rosa": "San Juan de Lurigancho", "Bayóvar": "San Juan de Lurigancho",
    "Gamarra": "La Victoria",
    "Puerto del Callao": "Cercado del Callao", "Buenos Aires": "Cercado del Callao",
    "Juan Pablo II": "Cercado del Callao",
    "Insurgentes": "Bellavista", "Óscar R. Benavides": "Bellavista",
    "San Marcos": "Breña", "Elio": "Breña", "La Alborada": "Breña",
    "Tingo María": "Breña", "Parque Murillo": "Breña", "Plaza Bolognesi": "Breña",
    "Plaza Manco Cápac": "La Victoria", "Cangallo": "La Victoria",
    "Nicolás Ayllón": "San Luis", "Circunvalación": "San Luis",
    "San Juan de Dios": "El Agustino",
    "Evitamiento": "Santa Anita", "Óvalo Santa Anita": "Santa Anita",
    "Colectora Industrial": "Santa Anita", "Hermilio Valdizán": "Santa Anita",
    "Mercado Santa Anita": "Santa Anita",
    "Vista Alegre": "Ate", "Prolongación Javier Prado": "Ate", "Municipalidad de Ate": "Ate",
    "El Álamo": "Comas", "Huandoy": "Los Olivos", "2 de Octubre": "Los Olivos",
    "Villa Sol": "Los Olivos", "Naranjal": "Los Olivos",
    "Carlos Izaguirre": "Independencia", "Tomás Valle": "Independencia",
    "Bartolomé de las Casas": "San Martín de Porres",
    "José Granda": "San Martín de Porres", "Caquetá": "Rímac",
    "Tacna": "Cercado de Lima", "Garcilaso de la Vega": "Cercado de Lima",
    "Parque de la Reserva": "Cercado de Lima",
    "Museo de Historia Natural": "Cercado de Lima", "César Canevaro": "Lince",
    "Andrés Aramburú": "San Isidro", "Huaca Pucllana": "Miraflores",
    "Parque Central de Miraflores": "Miraflores", "Parque Reducto": "Miraflores",
    "República de Panamá": "Miraflores", "Juana Alarco": "Miraflores",
    "Alejandro Velasco": "Santiago de Surco", "Las Gardenias": "Santiago de Surco",
    "Pedro Miotta": "San Juan de Miraflores",
    "Estación Central": "Cercado de Lima",
    "Conde de San Isidro": "San Isidro",
    "Cabitos": "Santiago de Surco",
    "Los Héroes": "San Juan de Miraflores",
    "28 de Julio": "La Victoria",
    "La Cultura": "San Borja",
    "Carmen de la Legua": "Carmen de la Legua Reynoso",
]

struct Cruce {
    let lineaA: String
    let lineaB: String
    let estacionL1: String
    let estacionL2: String
    let funcional: Bool
}

nonisolated(unsafe) var CRUCES: [Cruce] = [
    Cruce(lineaA: "Línea 1", lineaB: "Línea 2", estacionL1: "28 de Julio", estacionL2: "28 de Julio", funcional: false),
    Cruce(lineaA: "Línea 1", lineaB: "Línea 3", estacionL1: "Cabitos", estacionL2: "Cabitos", funcional: false),
    Cruce(lineaA: "Línea 1", lineaB: "Línea 3", estacionL1: "Atocongo", estacionL2: "Los Héroes", funcional: false),
    Cruce(lineaA: "Línea 1", lineaB: "Línea 4", estacionL1: "La Cultura", estacionL2: "La Cultura", funcional: false),
    Cruce(lineaA: "Línea 2", lineaB: "Línea 3", estacionL1: "Estación Central", estacionL2: "Estación Central", funcional: false),
    Cruce(lineaA: "Línea 2", lineaB: "Línea 4", estacionL1: "Carmen de la Legua", estacionL2: "Carmen de la Legua", funcional: false),
    Cruce(lineaA: "Línea 3", lineaB: "Línea 4", estacionL1: "Conde de San Isidro", estacionL2: "Conde de San Isidro", funcional: false),
]

struct PuntoInteres {
    let distrito: String
    let tipo: String
    let estacionCercana: String
    let lineaCercana: String
    let distanciaCuadras: Int?
}

let PUNTOS_INTERES: [String: PuntoInteres] = [
    "Estadio Nacional": PuntoInteres(distrito: "La Victoria", tipo: "Estadio / punto turístico", estacionCercana: "Gamarra", lineaCercana: "Línea 1", distanciaCuadras: 22),
    "Hospital Rebagliati": PuntoInteres(distrito: "Jesús María", tipo: "Hospital", estacionCercana: "Gamarra", lineaCercana: "Línea 1", distanciaCuadras: nil),
    "Real Plaza Salaverry": PuntoInteres(distrito: "Jesús María", tipo: "Centro comercial / supermercado", estacionCercana: "Felipe Salaverry", lineaCercana: "Línea 4", distanciaCuadras: nil),
]

let MINUTOS_POR_ESTACION: Double = 54.0 / 26.0
let MINUTOS_POR_CUADRA: Double = 1.0

let LINEA1_SIN_ASCENSOR: Set<String> = ["Pumacahua", "Villa María", "María Auxiliadora", "San Borja Sur"]

func tieneAscensor(_ nombreEstacion: String, _ lineas: [String]) -> String {
    if lineas.contains("Línea 1") {
        return LINEA1_SIN_ASCENSOR.contains(nombreEstacion) ? "No (cuenta con salvaescaleras)" : "Sí"
    }
    if lineas.contains("Línea 2") {
        if let operativas = LINEAS["Línea 2"]?.estacionesOperativas, operativas.contains(nombreEstacion) {
            return "Sí"
        }
        return "No verificado (estación aún no operativa)"
    }
    return "No verificado (línea aún no operativa)"
}

let LUGARES_CERCANOS: [String: [String]] = [
    "Gamarra": ["Emporio Comercial Gamarra"],
    "Miguel Grau": ["Centro Histórico de Lima"],
    "La Cultura": ["Museo de la Nación"],
    "Estación Central": ["Paseo Colón"],
    "Angamos": ["Zona comercial de Surquillo"],
]

struct Tarjeta {
    var saldo: Double
}
nonisolated(unsafe) var tarjetaUsuario = Tarjeta(saldo: 0.0)
let COSTO_PASAJE = 1.50
let COSTO_TARJETA_NUEVA = 5.00

// ============================================================
// RF01
// ============================================================

func mostrarEstaciones(_ nombreLinea: String) {
    guard let linea = LINEAS[nombreLinea] else {
        print("\n⚠ No existe la \"\(nombreLinea)\". Elige entre Línea 1, Línea 2, Línea 3 o Línea 4.")
        return
    }
    print("\n--- \(nombreLinea) ---")
    print("Origen: \(linea.estaciones.first!)")
    print("Destino: \(linea.estaciones.last!)")
    print("Estado: \(linea.estado)")
    print("\nEstaciones (\(linea.estaciones.count) en total):")
    for (indice, estacion) in linea.estaciones.enumerated() {
        print("\(indice + 1). \(estacion)")
    }
}

func mostrarInfoLinea(_ nombreLinea: String) {
    guard let linea = LINEAS[nombreLinea] else {
        print("\n⚠ No existe la \"\(nombreLinea)\".")
        return
    }
    let origen = linea.estaciones.first!
    let destino = linea.estaciones.last!
    let distritoOrigen = DISTRITOS[origen] ?? "No verificado"
    let distritoDestino = DISTRITOS[destino] ?? "No verificado"

    print("\n--- Información de la \(nombreLinea) ---")
    print("Estado: \(linea.estado)")
    print("Origen: \(origen) (\(distritoOrigen))")
    print("Destino: \(destino) (\(distritoDestino))")
    print("Cantidad de estaciones: \(linea.estaciones.count)")

    if let operativas = linea.estacionesOperativas {
        if !operativas.isEmpty {
            print("Estaciones operativas hoy: \(operativas.count) de \(linea.estaciones.count) (\(operativas.joined(separator: ", ")))")
        } else {
            print("Estaciones operativas hoy: ninguna")
        }
    } else {
        print("Estaciones operativas hoy: todas (\(linea.estaciones.count))")
    }

    let distritosUnicos = Array(Set(linea.estaciones.compactMap { DISTRITOS[$0] })).sorted()
    if distritosUnicos.isEmpty {
        print("Distritos que atraviesa: No verificado")
    } else {
        print("Distritos que atraviesa:")
        for distrito in distritosUnicos {
            print("- \(distrito)")
        }
    }
}

// ============================================================
// UTILIDADES
// ============================================================

func normalizar(_ texto: String) -> String {
    return texto.trimmingCharacters(in: .whitespaces)
        .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
}

func lineasDeEstacion(_ nombreEstacion: String) -> (nombreOficial: String?, lineas: [String]) {
    let objetivo = normalizar(nombreEstacion)
    var lineasEncontradas: [String] = []
    var nombreOficial: String? = nil
    for (nombreLinea, datosLinea) in LINEAS {
        for estacion in datosLinea.estaciones {
            if normalizar(estacion) == objetivo {
                lineasEncontradas.append(nombreLinea)
                nombreOficial = estacion
            }
        }
    }
    return (nombreOficial, lineasEncontradas)
}

func pedirNumero(_ mensaje: String, minimo: Int, maximo: Int, contexto: String = "") -> Int {
    while true {
        print(mensaje, terminator: "")
        guard let entrada = readLine(), let valor = Int(entrada.trimmingCharacters(in: .whitespaces)) else {
            print("⚠ Debes ingresar un número\(contexto.isEmpty ? "" : " " + contexto). Intenta de nuevo.")
            continue
        }
        if valor < minimo || valor > maximo {
            print("⚠ Elige un número entre \(minimo) y \(maximo). Intenta de nuevo.")
            continue
        }
        return valor
    }
}

func pedirTexto(_ mensaje: String, contexto: String = "") -> String {
    while true {
        print(mensaje, terminator: "")
        guard let entrada = readLine() else { continue }
        let limpio = entrada.trimmingCharacters(in: .whitespaces)
        if Int(limpio) != nil {
            print("⚠ Aquí se espera un nombre\(contexto.isEmpty ? "" : " " + contexto) (texto), no un número. Intenta de nuevo.")
            continue
        }
        if limpio.isEmpty {
            print("⚠ No puede quedar vacío. Intenta de nuevo.")
            continue
        }
        return limpio
    }
}

func elegirConOtro(_ opciones: [String], etiqueta: String, pedirLibre: () -> String) -> String {
    print("\n\(etiqueta)")
    for (i, opcion) in opciones.enumerated() {
        print("\(i + 1). \(opcion)")
    }
    print("\(opciones.count + 1). Otro (escribir manualmente)")
    let seleccion = pedirNumero("Elige un número: ", minimo: 1, maximo: opciones.count + 1,
                                 contexto: "(1 al \(opciones.count + 1))")
    if seleccion == opciones.count + 1 {
        return pedirLibre()
    }
    return opciones[seleccion - 1]
}

func repetirOSalir(_ accion: () -> Void) {
    while true {
        accion()
        print("\n¿Qué deseas hacer?")
        print("1. Consultar otra vez con esta misma opción")
        print("2. Volver al menú principal")
        let continuar = pedirNumero("Elige: ", minimo: 1, maximo: 2, contexto: "(1 o 2)")
        if continuar == 2 {
            print("\n" + String(repeating: "-", count: 50) + "\n")
            break
        }
    }
}
