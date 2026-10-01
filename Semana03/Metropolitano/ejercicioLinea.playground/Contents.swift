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

// ============================================================
// RF02
// ============================================================

struct FichaEstacion {
    let nombre: String
    let lineas: [String]
    let distrito: String
    let ascensores: String
    let estacionesCercanas: [String]
    let conexionMetropolitano: String
}

func obtenerFicha(_ nombreEstacion: String) -> FichaEstacion? {
    let (nombreOficial, lineas) = lineasDeEstacion(nombreEstacion)
    guard let nombre = nombreOficial else { return nil }
    let metropolitano = (nombre == "Estación Central") ? "Sí" : "No"
    return FichaEstacion(
        nombre: nombre, lineas: lineas, distrito: DISTRITOS[nombre] ?? "No verificado",
        ascensores: tieneAscensor(nombre, lineas),
        estacionesCercanas: estacionesCercanas(nombre), conexionMetropolitano: metropolitano
    )
}

func mostrarFicha(_ nombreEstacion: String) {
    guard let ficha = obtenerFicha(nombreEstacion) else {
        print("\n⚠ La estación \"\(nombreEstacion)\" no fue encontrada. Verifica el nombre e intenta de nuevo.")
        return
    }
    print("\n--- Ficha de estación ---")
    print("Nombre: \(ficha.nombre)")
    print("Línea(s): \(ficha.lineas.joined(separator: ", "))")
    print("Distrito: \(ficha.distrito)")
    print("Ascensores: \(ficha.ascensores)")
    if ficha.estacionesCercanas.isEmpty {
        print("Estaciones cercanas: No verificado (sin distrito confirmado o sin otras estaciones registradas en la zona)")
    } else {
        print("Estaciones cercanas:")
        for cercana in ficha.estacionesCercanas {
            print("- \(cercana)")
        }
    }
    print("Conexión con Metropolitano: \(ficha.conexionMetropolitano)")
}

// ============================================================
// RF03
// ============================================================

func conexionesDeEstacion(_ nombreEstacion: String) -> (nombreOficial: String?, lineasEstacion: [String], resultados: [(String, String, Bool)]) {
    let (nombreOficial, lineasEstacion) = lineasDeEstacion(nombreEstacion)
    guard let nombre = nombreOficial else { return (nil, [], []) }
    var resultados: [(String, String, Bool)] = []
    for cruce in CRUCES {
        if lineasEstacion.contains(cruce.lineaA) && cruce.estacionL1 == nombre {
            resultados.append((cruce.estacionL2, cruce.lineaB, cruce.funcional))
        } else if lineasEstacion.contains(cruce.lineaB) && cruce.estacionL2 == nombre {
            resultados.append((cruce.estacionL1, cruce.lineaA, cruce.funcional))
        }
    }
    return (nombre, lineasEstacion, resultados)
}

func conexionesDeLinea(_ nombreLinea: String) -> [(String, String, Bool)] {
    var resultados: [(String, String, Bool)] = []
    for cruce in CRUCES {
        if cruce.lineaA == nombreLinea {
            resultados.append((cruce.estacionL1, cruce.lineaB, cruce.funcional))
        } else if cruce.lineaB == nombreLinea {
            resultados.append((cruce.estacionL2, cruce.lineaA, cruce.funcional))
        }
    }
    return resultados
}

func estadoTexto(_ funcional: Bool) -> String {
    return funcional ? "funcional" : "no funcional aún"
}

func mostrarConexionEstacion(_ nombreEstacion: String) {
    let (nombreOficial, lineasEstacion, conexiones) = conexionesDeEstacion(nombreEstacion)
    guard let nombre = nombreOficial else {
        print("\n⚠ La estación \"\(nombreEstacion)\" no fue encontrada.")
        return
    }
    print("\n--- Conexión ---")
    print("Estación: \(nombre) (pertenece a: \(lineasEstacion.joined(separator: ", ")))")
    if conexiones.isEmpty {
        print("Esta estación no es un punto de cruce con otra línea.")
        return
    }
    for (estacionDestino, lineaDestino, funcional) in conexiones {
        if normalizar(estacionDestino) == normalizar(nombre) {
            print("Conecta con la \(lineaDestino) en la misma estación (\(estadoTexto(funcional))).")
        } else {
            print("Conecta con la \(lineaDestino) en la estación \"\(estacionDestino)\" (\(estadoTexto(funcional))).")
        }
    }
}

func mostrarConexionesLinea(_ nombreLinea: String) {
    let cruces = conexionesDeLinea(nombreLinea)
    print("\n--- Conexiones de la \(nombreLinea) (\(cruces.count) cruces) ---")
    if cruces.isEmpty {
        print("Esta línea no tiene cruces registrados.")
        return
    }
    for (estacion, lineaDestino, funcional) in cruces {
        print("- \(estacion) → \(lineaDestino) (\(estadoTexto(funcional)))")
    }
}

// ============================================================
// RF04
// ============================================================

func grafoDeLineas() -> [String: [(String, String, Bool)]] {
    var grafo: [String: [(String, String, Bool)]] = [:]
    for cruce in CRUCES {
        grafo[cruce.lineaA, default: []].append((cruce.lineaB, cruce.estacionL2, cruce.funcional))
        grafo[cruce.lineaB, default: []].append((cruce.lineaA, cruce.estacionL1, cruce.funcional))
    }
    return grafo
}

func buscarRuta(_ nombreEstacionOrigen: String, _ lineaDestino: String)
    -> (nombreOficial: String?, lineaOrigen: String?, pasos: [(String, String, Bool)]??) {
    let (nombreOficial, lineasOrigen) = lineasDeEstacion(nombreEstacionOrigen)
    guard let nombre = nombreOficial else { return (nil, nil, nil) }
    if lineasOrigen.contains(lineaDestino) {
        return (nombre, lineasOrigen[0], .some([]))
    }
    let grafo = grafoDeLineas()
    for lineaOrigen in lineasOrigen {
        for (vecina, estacion, funcional) in grafo[lineaOrigen] ?? [] {
            if vecina == lineaDestino {
                return (nombre, lineaOrigen, .some([(estacion, lineaDestino, funcional)]))
            }
        }
        for (vecina, estacion1, funcional1) in grafo[lineaOrigen] ?? [] {
            for (vecina2, estacion2, funcional2) in grafo[vecina] ?? [] {
                if vecina2 == lineaDestino {
                    return (nombre, lineaOrigen, .some([(estacion1, vecina, funcional1), (estacion2, lineaDestino, funcional2)]))
                }
            }
        }
    }
    return (nombre, lineasOrigen[0], .some(nil))
}

func mostrarAvisoOperativo() {
    print("\n⚠ Ten en cuenta: esa conexión física entre líneas todavía está en construcción o en proyecto, "
        + "no se puede hacer ese transbordo en la realidad todavía.")
    print("Mientras tanto, esto sí puedes usar hoy:")
    print("- Línea 1: completa y operativa (Villa El Salvador ↔ Bayóvar).")
    print("- Línea 2: tramo operativo entre Evitamiento y Mercado Santa Anita.")
}

func mostrarRuta(_ nombreEstacionOrigen: String, _ lineaDestino: String) {
    let (nombreOficial, lineaOrigen, pasosOpt) = buscarRuta(nombreEstacionOrigen, lineaDestino)
    guard let nombre = nombreOficial, let origen = lineaOrigen else {
        print("\n⚠ La estación \"\(nombreEstacionOrigen)\" no fue encontrada.")
        return
    }
    print("\n--- Ruta sugerida ---")
    print("Origen: \(nombre) (\(origen))")
    guard let pasos = pasosOpt ?? nil else {
        print("No se encontró una ruta hacia \(lineaDestino) con los cruces disponibles.")
        return
    }
    if pasos.isEmpty {
        print("Ya te encuentras en la \(lineaDestino), no necesitas transbordo.")
        return
    }
    var hayNoFuncional = false
    for (estacion, lineaSiguiente, funcional) in pasos {
        print("Debes bajar en: \(estacion) → conecta con \(lineaSiguiente) (\(estadoTexto(funcional)))")
        if !funcional { hayNoFuncional = true }
    }
    if hayNoFuncional {
        mostrarAvisoOperativo()
    }
}

// ============================================================
// RF06
// ============================================================

let ESTADOS = ["operativa", "construcción", "proyecto"]

func lineasPorEstado(_ estado: String) -> [String] {
    if estado == "operativa" {
        return LINEAS.filter { _, datos in
            datos.estado == "operativa" || !(datos.estacionesOperativas ?? []).isEmpty
        }.map { $0.key }.sorted()
    }
    return LINEAS.filter { $0.value.estado == estado }.map { $0.key }.sorted()
}

func descripcionLinea(_ nombreLinea: String) -> String {
    let datos = LINEAS[nombreLinea]!
    let inicio = datos.estaciones.first!
    let fin = datos.estaciones.last!
    if datos.estado == "operativa" {
        return "\(nombreLinea) (\(inicio) - \(fin))"
    }
    if let operativas = datos.estacionesOperativas, !operativas.isEmpty {
        return "\(nombreLinea) (parcial: \(operativas.count) de \(datos.estaciones.count) estaciones operativas)"
    }
    return "\(nombreLinea) (\(inicio) - \(fin), \(datos.estado))"
}

func flujoFiltrarPorEstado() {
    print("\nFiltrar líneas por estado:")
    print("1. Operativas")
    print("2. En construcción")
    print("3. En proyecto")
    let opcion = pedirNumero("Elige: ", minimo: 1, maximo: 3, contexto: "de estado (1 al 3)")
    let estado = ESTADOS[opcion - 1]
    let lineas = lineasPorEstado(estado)
    let tituloEstado = estado == "construcción" ? "en construcción" : estado + "s"
    print("\n--- Líneas \(tituloEstado) ---")
    if lineas.isEmpty {
        print("No hay líneas con ese estado.")
        return
    }
    for (i, nombre) in lineas.enumerated() {
        print("\(i + 1). \(descripcionLinea(nombre))")
    }
    print("\(lineas.count + 1). Otro (volver al menú anterior)")
    let seleccion = pedirNumero(
        "Selecciona una línea para ver sus estaciones: ", minimo: 1, maximo: lineas.count + 1,
        contexto: "de línea (1 al \(lineas.count + 1))")
    if seleccion == lineas.count + 1 {
        print("\nVolviendo al menú anterior...")
        return
    }
    let lineaElegida = lineas[seleccion - 1]
    mostrarEstaciones(lineaElegida)
    let datosLinea = LINEAS[lineaElegida]!
    if let operativas = datosLinea.estacionesOperativas {
        if !operativas.isEmpty {
            print("\nEstaciones operativas: \(operativas.joined(separator: ", "))")
        } else {
            print("\nNinguna estación de esta línea está operativa todavía.")
        }
    }
}

// ============================================================
// RF07
// ============================================================

func buscarPorDistrito(_ nombreDistrito: String) -> [(estacion: String, lineas: [String])] {
    let objetivo = normalizar(nombreDistrito)
    var encontradas: [String: Set<String>] = [:]
    for (nombreLinea, datosLinea) in LINEAS {
        for estacion in datosLinea.estaciones {
            if let distritoEstacion = DISTRITOS[estacion], normalizar(distritoEstacion) == objetivo {
                encontradas[estacion, default: []].insert(nombreLinea)
            }
        }
    }
    return encontradas.map { (estacion: $0.key, lineas: Array($0.value).sorted()) }
        .sorted { $0.estacion < $1.estacion }
}

func estacionesCercanas(_ nombreEstacion: String) -> [String] {
    guard let distrito = DISTRITOS[nombreEstacion] else { return [] }
    let mismasDelDistrito = buscarPorDistrito(distrito)
    return mismasDelDistrito
        .map { $0.estacion }
        .filter { normalizar($0) != normalizar(nombreEstacion) }
}

func mostrarEstacionesPorDistrito(_ nombreDistrito: String) {
    let encontradas = buscarPorDistrito(nombreDistrito)
    if encontradas.isEmpty {
        print("\n⚠ No se encontraron estaciones registradas en \"\(nombreDistrito)\". " +
              "Puede que el distrito no exista en el sistema, o que aún no se haya verificado el dato para esa zona.")
        return
    }
    print("\n--- Estaciones en \(nombreDistrito) (\(encontradas.count)) ---")
    var lineasDelDistrito: Set<String> = []
    for (i, item) in encontradas.enumerated() {
        print("\(i + 1). \(item.estacion) (\(item.lineas.joined(separator: ", ")))")
        lineasDelDistrito.formUnion(item.lineas)
    }
    print("\nLíneas que pasan por \(nombreDistrito):")
    for linea in lineasDelDistrito.sorted() {
        print("- \(linea)")
    }
}

// ============================================================
// RF08
// ============================================================

func distritosConocidos() -> [String] {
    return Array(Set(DISTRITOS.values)).sorted()
}

func estacionMasCercanaADistrito(_ nombreDistrito: String) -> (estacion: String?, linea: String?) {
    let encontradas = buscarPorDistrito(nombreDistrito)
    guard let primera = encontradas.first else { return (nil, nil) }
    return (primera.estacion, primera.lineas.sorted().first)
}

func flujoPuntoInteres() {
    let distritos = distritosConocidos()
    let zona = elegirConOtro(distritos, etiqueta: "¿En qué distrito o zona te encuentras ahora?") {
        pedirTexto("Escribe el nombre de tu distrito o zona: ", contexto: "de zona")
    }
    let (estacionOrigen, lineaOrigen) = estacionMasCercanaADistrito(zona)
    guard let origen = estacionOrigen, let linea = lineaOrigen else {
        print("\n⚠ No tengo información de estaciones cercanas a \"\(zona)\" en este momento.")
        return
    }
    print("\n--- Buscando estación más cercana a \(zona)... ---")
    print("Estación de origen sugerida: \(origen) (\(linea))")
    let destinos = Array(PUNTOS_INTERES.keys).sorted()
    let destino = elegirConOtro(destinos, etiqueta: "¿A dónde quieres ir?") {
        pedirTexto("Escribe tu destino: ", contexto: "de destino")
    }
    let destinoNormalizado = normalizar(destino)
    var punto: PuntoInteres? = nil
    for (nombre, datosPunto) in PUNTOS_INTERES {
        if normalizar(nombre) == destinoNormalizado {
            punto = datosPunto
            break
        }
    }
    guard let p = punto else {
        print("\n⚠ No tengo registrado \"\(destino)\" como punto de interés todavía.")
        return
    }
    print("\n--- Ruta sugerida ---")
    print("Destino: \(destino) (\(p.distrito))")
    let (_, lineaO, pasosOpt) = buscarRuta(origen, p.lineaCercana)
    var pasoNum = 1
    var hayNoFuncional = false
    if let pasos = pasosOpt ?? nil {
        if pasos.isEmpty {
            print("\(pasoNum). Ya estás en la \(p.lineaCercana), sin necesidad de transbordo.")
            pasoNum += 1
        } else {
            print("\(pasoNum). Aborda la \(lineaO ?? linea) en \"\(origen)\"")
            pasoNum += 1
            for (estacionTransbordo, lineaSiguiente, funcional) in pasos {
                print("\(pasoNum). Baja en \"\(estacionTransbordo)\" y transborda a \(lineaSiguiente)")
                pasoNum += 1
                if !funcional { hayNoFuncional = true }
            }
        }
    } else {
        print("No se encontró ruta en metro hacia esa zona.")
    }
    if let distancia = p.distanciaCuadras {
        let minutosCaminata = Int(Double(distancia) * MINUTOS_POR_CUADRA)
        print("\(pasoNum). Baja en \"\(p.estacionCercana)\" y camina ~\(distancia) cuadras hasta \(destino) — aprox. \(minutosCaminata) min")
        print("\n⏱ Tiempo estimado caminando: ~\(minutosCaminata) min (estimado, no oficial: 1 min/cuadra)")
    }
    if hayNoFuncional {
        mostrarAvisoOperativo()
    }
}

func calcularTiempoEntreEstaciones(_ nombreOrigen: String, _ nombreDestino: String) -> (linea: String, distancia: Int, minutos: Int)?? {
    let (_, lineasOrigen) = lineasDeEstacion(nombreOrigen)
    let (nombreDestinoOficial, lineasDestino) = lineasDeEstacion(nombreDestino)
    if lineasOrigen.isEmpty || lineasDestino.isEmpty || nombreDestinoOficial == nil {
        return nil
    }
    let lineasComunes = Set(lineasOrigen).intersection(Set(lineasDestino))
    if lineasComunes.isEmpty {
        return .some(nil)
    }
    let linea = lineasComunes.sorted().first!
    let estaciones = LINEAS[linea]!.estaciones
    let objetivoOrigen = normalizar(nombreOrigen)
    let objetivoDestino = normalizar(nombreDestino)
    guard let idxOrigen = estaciones.firstIndex(where: { normalizar($0) == objetivoOrigen }),
          let idxDestino = estaciones.firstIndex(where: { normalizar($0) == objetivoDestino }) else {
        return nil
    }
    let distancia = abs(idxDestino - idxOrigen)
    let minutos = Int((Double(distancia) * MINUTOS_POR_ESTACION).rounded())
    return .some((linea, distancia, minutos))
}

func mostrarTiempoEntreEstaciones(_ nombreOrigen: String, _ nombreDestino: String) {
    let (origenOficial, _) = lineasDeEstacion(nombreOrigen)
    let (destinoOficial, _) = lineasDeEstacion(nombreDestino)

    if origenOficial == nil && destinoOficial == nil {
        print("\n⚠ Ninguna de las dos estaciones fue encontrada: \"\(nombreOrigen)\" y \"\(nombreDestino)\". Verifica los nombres.")
        return
    }
    if origenOficial == nil {
        print("\n⚠ La estación de origen \"\(nombreOrigen)\" no fue encontrada. Verifica el nombre.")
        return
    }
    if destinoOficial == nil {
        print("\n⚠ La estación de destino \"\(nombreDestino)\" no fue encontrada. Verifica el nombre.")
        return
    }

    guard let resultadoOpt = calcularTiempoEntreEstaciones(nombreOrigen, nombreDestino) else {
        print("\n⚠ No se pudo calcular la distancia entre estas estaciones.")
        return
    }
    guard let resultado = resultadoOpt else {
        print("\n⚠ Estas estaciones pertenecen a líneas distintas y sin cruce directo entre ellas; "
            + "usa la opción de buscar ruta de transbordo para ese caso.")
        return
    }
    print("\n--- Tiempo estimado ---")
    print("\(nombreOrigen) → \(nombreDestino) (\(resultado.linea)): \(resultado.distancia) estaciones de distancia")
    print("Tiempo estimado: ~\(resultado.minutos) min (estimado, ~2 min/estación)")
}

// ============================================================
// RF10
// ============================================================

func tramoConContador(_ nombreLinea: String, _ desde: String, _ hasta: String) {
    let arr = LINEAS[nombreLinea]!.estaciones
    guard let iD = arr.firstIndex(where: { normalizar($0) == normalizar(desde) }),
          let iH = arr.firstIndex(where: { normalizar($0) == normalizar(hasta) }) else { return }
    let paso = iH > iD ? 1 : -1
    var i = iD
    var faltan = abs(iH - iD)
    while i != iH {
        print("En \(arr[i]) (\(nombreLinea)) — faltan \(faltan) estaciones para llegar a \(arr[iH]) "
            + "(≈\(Int((Double(faltan) * MINUTOS_POR_ESTACION).rounded())) min)")
        i += paso
        faltan -= 1
    }
    print("Llegada: \(arr[iH]) (\(nombreLinea)) — 0 estaciones restantes")
}

func planificarViaje(_ nombreOrigen: String, _ nombreDestino: String) {
    let (nO, lineasO) = lineasDeEstacion(nombreOrigen)
    let (nD, lineasD) = lineasDeEstacion(nombreDestino)
    guard let origen = nO, let destino = nD else {
        print("\n⚠ Una o ambas estaciones no fueron encontradas. Verifica los nombres.")
        return
    }
    let comunes = Set(lineasO).intersection(lineasD)
    print("\n--- Planificación de viaje ---")
    if let linea = comunes.sorted().first {
        tramoConContador(linea, origen, destino)
        return
    }
    for lo in lineasO {
        for cruce in CRUCES {
            var lineaFinal: String? = nil
            var estacionSalida: String? = nil
            var estacionEntrada: String? = nil
            if cruce.lineaA == lo && lineasD.contains(cruce.lineaB) {
                lineaFinal = cruce.lineaB; estacionSalida = cruce.estacionL1; estacionEntrada = cruce.estacionL2
            } else if cruce.lineaB == lo && lineasD.contains(cruce.lineaA) {
                lineaFinal = cruce.lineaA; estacionSalida = cruce.estacionL2; estacionEntrada = cruce.estacionL1
            }
            if let lf = lineaFinal, let es = estacionSalida, let ee = estacionEntrada {
                tramoConContador(lo, origen, es)
                print("--- Transbordo a \(lf) (\(cruce.funcional ? "funcional" : "no funcional aún")) ---")
                tramoConContador(lf, ee, destino)
                return
            }
        }
    }
    print("No se encontró una ruta entre estas estaciones con los cruces disponibles.")
}

func tiempoASiguienteEstacion(_ nombreEstacion: String) {
    let (nombre, lineas) = lineasDeEstacion(nombreEstacion)
    guard let est = nombre else {
        print("\n⚠ La estación \"\(nombreEstacion)\" no fue encontrada.")
        return
    }
    print("\n--- Siguiente estación desde \(est) ---")
    for linea in lineas {
        let arr = LINEAS[linea]!.estaciones
        guard let idx = arr.firstIndex(of: est) else { continue }
        if idx + 1 < arr.count {
            let minutos = Int(MINUTOS_POR_ESTACION.rounded())
            print("(\(linea)) Próxima estación: \(arr[idx + 1]) — aprox. \(minutos) min")
        } else {
            print("(\(linea)) \(est) es la última estación de esta línea.")
        }
    }
}

func mostrarLugaresCercanos(_ nombreEstacion: String) {
    let (nombre, _) = lineasDeEstacion(nombreEstacion)
    guard let est = nombre else {
        print("\n⚠ La estación \"\(nombreEstacion)\" no fue encontrada.")
        return
    }
    print("\n--- Lugares cercanos a \(est) ---")
    if let lugares = LUGARES_CERCANOS[est], !lugares.isEmpty {
        for l in lugares { print("- \(l)") }
    } else {
        print("No verificado (aún no se registró un lugar de interés cercano a esta estación).")
    }
}

// ============================================================
// RF11
// ============================================================

func mostrarSaldo() {
    print("\n--- Tarjeta de transporte ---")
    print(String(format: "Saldo actual: S/ %.2f", tarjetaUsuario.saldo))
}

func recargarTarjeta() {
    let montoTexto = pedirTexto("\nIngresa el monto a recargar (S/): ", contexto: "de monto")
    guard let monto = Double(montoTexto), monto > 0 else {
        print("⚠ Monto inválido.")
        return
    }
    tarjetaUsuario.saldo += monto
    print(String(format: "Recarga exitosa. Nuevo saldo: S/ %.2f", tarjetaUsuario.saldo))
}

func pagarPasaje() {
    print(String(format: "\nCosto del pasaje: S/ %.2f", COSTO_PASAJE))
    if tarjetaUsuario.saldo >= COSTO_PASAJE {
        tarjetaUsuario.saldo -= COSTO_PASAJE
        print(String(format: "Pasaje pagado. Saldo restante: S/ %.2f", tarjetaUsuario.saldo))
    } else {
        print(String(format: "⚠ Saldo insuficiente (S/ %.2f). Recarga tu tarjeta.", tarjetaUsuario.saldo))
    }
}

// ============================================================
// RF12
// ============================================================

func adminAgregarEstacion() {
    let linea = elegirLinea()
    let nombre = pedirTexto("Nombre de la nueva estación: ", contexto: "de estación")
    guard let datos = LINEAS[linea] else { return }
    LINEAS[linea] = LineaInfo(estado: datos.estado, estaciones: datos.estaciones + [nombre], estacionesOperativas: datos.estacionesOperativas)
    print("✅ Estación \"\(nombre)\" agregada a \(linea).")
}

func adminCrearLinea() {
    let nombre = pedirTexto("\nNombre de la nueva línea (ej. Línea 5): ", contexto: "de línea")
    let estado = pedirTexto("Estado (operativa / construcción / proyecto): ", contexto: "de estado")
    var estaciones: [String] = []
    print("Ingresa las estaciones una por una. Escribe \"fin\" para terminar.")
    while true {
        let est = pedirTexto("Estación: ", contexto: "de estación")
        if normalizar(est) == "fin" { break }
        estaciones.append(est)
    }
    LINEAS[nombre] = LineaInfo(estado: estado, estaciones: estaciones, estacionesOperativas: estado == "operativa" ? nil : [])
    print("✅ \(nombre) creada con \(estaciones.count) estaciones.")
}

func adminEditarLinea() {
    let linea = elegirLinea()
    guard let datos = LINEAS[linea] else { return }
    let nuevoEstado = pedirTexto("Nuevo estado para \(linea) (operativa / construcción / proyecto): ", contexto: "de estado")
    LINEAS[linea] = LineaInfo(estado: nuevoEstado, estaciones: datos.estaciones, estacionesOperativas: datos.estacionesOperativas)
    print("✅ \(linea) actualizada. Nuevo estado: \(nuevoEstado)")
}

func flujoAdmin() {
    print("\n--- Modo administrador ---")
    print("1. Agregar estación a línea existente")
    print("2. Crear línea nueva")
    print("3. Editar/modificar línea existente")
    let op = pedirNumero("Elige: ", minimo: 1, maximo: 3, contexto: "(1 al 3)")
    if op == 1 { adminAgregarEstacion() }
    else if op == 2 { adminCrearLinea() }
    else { adminEditarLinea() }
}

// ============================================================
// MENÚ PRINCIPAL
// ============================================================

func elegirLinea() -> String {
    print("\nLíneas disponibles:")
    let nombres = Array(LINEAS.keys).sorted()
    for (i, nombre) in nombres.enumerated() {
        print("\(i + 1). \(nombre)")
    }
    let opcion = pedirNumero("Elige un número de línea: ", minimo: 1, maximo: nombres.count, contexto: "de línea (1 al \(nombres.count))")
    return nombres[opcion - 1]
}

func opcion1VerEstaciones() {
    let linea = elegirLinea()
    mostrarEstaciones(linea)
}

func opcion2BuscarEstacion() {
    let nombre = pedirTexto("\nIngresa el nombre de la estación: ", contexto: "de estación")
    mostrarFicha(nombre)
}

func opcion3Conexiones() {
    print("\n1. Consultar conexiones de una estación")
    print("2. Consultar conexiones de una línea completa")
    let sub = pedirNumero("Elige una opción: ", minimo: 1, maximo: 2, contexto: "(1 o 2)")
    if sub == 1 {
        let nombre = pedirTexto("Ingresa el nombre de la estación: ", contexto: "de estación")
        mostrarConexionEstacion(nombre)
    } else {
        let linea = elegirLinea()
        mostrarConexionesLinea(linea)
    }
}

func opcion4RutaTransbordo() {
    let origen = pedirTexto("\nIngresa tu estación de origen: ", contexto: "de estación")
    print("¿A qué línea deseas llegar?")
    let lineaDestino = elegirLinea()
    mostrarRuta(origen, lineaDestino)
}

func opcion6BuscarDistrito() {
    let distrito = pedirTexto("\nIngresa el distrito: ", contexto: "de distrito")
    mostrarEstacionesPorDistrito(distrito)
}

func opcion8TiempoEntreEstaciones() {
    let origen = pedirTexto("\nIngresa estación de origen: ", contexto: "de estación")
    let destino = pedirTexto("Ingresa estación de destino: ", contexto: "de estación")
    mostrarTiempoEntreEstaciones(origen, destino)
}

func opcion9InfoLinea() {
    let linea = elegirLinea()
    mostrarInfoLinea(linea)
}

func mostrarMenu() {
    print("=== Simulador Metro de Lima ===")
    print("\n--- Funciones principales ---")
    print("1. Ver estaciones de una línea")
    print("2. Buscar estación")
    print("3. Consultar conexión de una estación o línea")
    print("4. Buscar ruta de transbordo")
    print("\n--- Funciones adicionales ---")
    print("5. Filtrar líneas por estado")
    print("6. Buscar estaciones por distrito")
    print("7. Planificar ruta a un punto de interés")
    print("8. Calcular tiempo entre dos estaciones")
    print("9. Ver información general de una línea")
    print("10. Planificar viaje completo (estación a estación)")
    print("11. Ver siguiente estación desde donde estoy")
    print("12. Ver lugares cercanos a una estación")
    print("13. Ver saldo de tarjeta")
    print("14. Recargar tarjeta")
    print("15. Pagar pasaje")
    print("16. Modo administrador")
    print("\n17. Salir")
}

func iniciar() {
    while true {
        mostrarMenu()
        let opcion = pedirNumero("\nElige una opción: ", minimo: 1, maximo: 17, contexto: "del menú (1 al 17)")

        switch opcion {
        case 1: repetirOSalir { opcion1VerEstaciones() }
        case 2: repetirOSalir { opcion2BuscarEstacion() }
        case 3: repetirOSalir { opcion3Conexiones() }
        case 4: repetirOSalir { opcion4RutaTransbordo() }
        case 5: repetirOSalir { flujoFiltrarPorEstado() }
        case 6: repetirOSalir { opcion6BuscarDistrito() }
        case 7: repetirOSalir { flujoPuntoInteres() }
        case 8: repetirOSalir { opcion8TiempoEntreEstaciones() }
        case 9: repetirOSalir { opcion9InfoLinea() }
        case 10: repetirOSalir {
            let o = pedirTexto("\nEstación de origen: ", contexto: "de estación")
            let d = pedirTexto("Estación de destino: ", contexto: "de estación")
            planificarViaje(o, d)
        }
        case 11: repetirOSalir {
            let e = pedirTexto("\nIngresa tu estación actual: ", contexto: "de estación")
            tiempoASiguienteEstacion(e)
        }
        case 12: repetirOSalir {
            let e = pedirTexto("\nIngresa la estación: ", contexto: "de estación")
            mostrarLugaresCercanos(e)
        }
        case 13: repetirOSalir { mostrarSaldo() }
        case 14: repetirOSalir { recargarTarjeta() }
        case 15: repetirOSalir { pagarPasaje() }
        case 16: repetirOSalir { flujoAdmin() }
        case 17:
            print("\n¡Hasta pronto!")
            return
        default:
            break
        }
    }
}

iniciar()
