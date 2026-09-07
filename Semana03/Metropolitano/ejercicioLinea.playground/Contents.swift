import Foundation

// ============================================================
// DATOS BASE
// ============================================================

struct LineaInfo {
    let estado: String
    let estaciones: [String]
    let estacionesOperativas: [String]?
}

let LINEAS: [String: LineaInfo] = [
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

let LINEA1_SIN_ASCENSOR: Set<String> = ["Pumacahua", "Villa María", "María Auxiliadora", "San Borja Sur"]

struct FichaExtra {
    let avenidaCercana: String
}

let FICHAS: [String: FichaExtra] = [
    "Cabitos": FichaExtra(avenidaCercana: "Cruce de Av. Aviación con Óvalo Cabitos (Higuereta)"),
    "Presbítero Maestro": FichaExtra(avenidaCercana: "Av. Locumba, cerca al cementerio Presbítero Maestro"),
]

let DISTRITOS: [String: String] = [
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

let CRUCES: [Cruce] = [
    Cruce(lineaA: "Línea 1", lineaB: "Línea 2", estacionL1: "28 de Julio", estacionL2: "28 de Julio", funcional: false),
    Cruce(lineaA: "Línea 1", lineaB: "Línea 3", estacionL1: "Cabitos", estacionL2: "Cabitos", funcional: false),
    Cruce(lineaA: "Línea 1", lineaB: "Línea 3", estacionL1: "Atocongo", estacionL2: "Los Héroes", funcional: false),
    Cruce(lineaA: "Línea 1", lineaB: "Línea 4", estacionL1: "La Cultura", estacionL2: "La Cultura", funcional: false),
    Cruce(lineaA: "Línea 2", lineaB: "Línea 3", estacionL1: "Estación Central", estacionL2: "Estación Central", funcional: false),
    Cruce(lineaA: "Línea 2", lineaB: "Línea 4", estacionL1: "Carmen de la Legua", estacionL2: "Carmen de la Legua", funcional: false),
    Cruce(lineaA: "Línea 3", lineaB: "Línea 4", estacionL1: "Conde de San Isidro", estacionL2: "Conde de San Isidro", funcional: false),
]

// ============================================================
// RF01 — Listar estaciones por línea
// ============================================================

func mostrarEstaciones(_ nombreLinea: String) {
    guard let linea = LINEAS[nombreLinea] else {
        print("\n⚠ No existe la \"\(nombreLinea)\". Elige entre Línea 1, Línea 2, Línea 3 o Línea 4.")
        return
    }

    print("\n--- Estaciones de la \(nombreLinea) (\(linea.estaciones.count) estaciones) ---")
    for (indice, estacion) in linea.estaciones.enumerated() {
        print("\(indice + 1). \(estacion)")
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

// ============================================================
// RF02 — Buscar estación y ver ficha de detalle
// ============================================================

struct FichaEstacion {
    let nombre: String
    let lineas: [String]
    let distrito: String
    let ascensores: String
    let avenidaCercana: String
    let conexionMetropolitano: String
}

func obtenerFicha(_ nombreEstacion: String) -> FichaEstacion? {
    let (nombreOficial, lineas) = lineasDeEstacion(nombreEstacion)
    guard let nombre = nombreOficial else { return nil }

    let ascensores: String
    if lineas.contains("Línea 1") {
        ascensores = LINEA1_SIN_ASCENSOR.contains(nombre) ? "No" : "Sí"
    } else {
        ascensores = "No aplica (línea aún no operativa)"
    }

    let avenida = FICHAS[nombre]?.avenidaCercana ?? "No verificado"
    let metropolitano = (nombre == "Estación Central") ? "Sí" : "No"

    return FichaEstacion(
        nombre: nombre,
        lineas: lineas,
        distrito: DISTRITOS[nombre] ?? "No verificado",
        ascensores: ascensores,
        avenidaCercana: avenida,
        conexionMetropolitano: metropolitano
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
    print("Avenida cercana: \(ficha.avenidaCercana)")
    print("Conexión con Metropolitano: \(ficha.conexionMetropolitano)")
}

// ============================================================
// RF03 — Consultar conexiones entre líneas
// ============================================================

func conexionesDeEstacion(_ nombreEstacion: String) -> (nombreOficial: String?, resultados: [(String, Bool)]) {
    let (nombreOficial, lineasEstacion) = lineasDeEstacion(nombreEstacion)
    guard let nombre = nombreOficial else { return (nil, []) }

    var resultados: [(String, Bool)] = []
    for cruce in CRUCES {
        if lineasEstacion.contains(cruce.lineaA) && cruce.estacionL1 == nombre {
            resultados.append((cruce.lineaB, cruce.funcional))
        } else if lineasEstacion.contains(cruce.lineaB) && cruce.estacionL2 == nombre {
            resultados.append((cruce.lineaA, cruce.funcional))
        }
    }
    return (nombre, resultados)
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
    let (nombreOficial, conexiones) = conexionesDeEstacion(nombreEstacion)
    guard let nombre = nombreOficial else {
        print("\n⚠ La estación \"\(nombreEstacion)\" no fue encontrada.")
        return
    }

    print("\n--- Conexión ---")
    if conexiones.isEmpty {
        print("\(nombre) no es un punto de cruce con otra línea.")
        return
    }
    for (lineaDestino, funcional) in conexiones {
        print("\(nombre) conecta con la \(lineaDestino) (\(estadoTexto(funcional))).")
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
// RF04 — Buscar ruta de transbordo
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

    for (estacion, lineaSiguiente, funcional) in pasos {
        print("Debes bajar en: \(estacion) → conecta con \(lineaSiguiente) (\(estadoTexto(funcional)))")
    }
}

// ============================================================
// RF06 — Filtrar líneas por estado
// ============================================================

let ESTADOS = ["operativa", "construcción", "proyecto"]

func lineasPorEstado(_ estado: String) -> [String] {
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
    print("\n--- Líneas \(estado == "construcción" ? "en construcción" : estado + "s") ---")

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
// RF07 — Buscar estaciones por distrito
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
    print("\nLíneas que pasan por \(nombreDistrito): \(lineasDelDistrito.sorted().joined(separator: ", "))")
}

// ============================================================
// MENÚ PRINCIPAL (RF05)
// ============================================================

let nombresLineas = ["Línea 1", "Línea 2", "Línea 3", "Línea 4"]

func elegirLinea() -> String {
    print("\nLíneas disponibles:")
    for (i, nombre) in nombresLineas.enumerated() {
        print("\(i + 1). \(nombre)")
    }
    let opcion = pedirNumero("Elige un número de línea: ", minimo: 1, maximo: 4, contexto: "de línea (1 al 4)")
    return nombresLineas[opcion - 1]
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

func mostrarMenu() {
    print("\n=== Simulador Metro de Lima ===")
    print("1. Ver estaciones de una línea")
    print("2. Buscar estación")
    print("3. Consultar conexión de una estación (o de una línea completa)")
    print("4. Buscar ruta de transbordo")
    print("5. Filtrar líneas por estado")
    print("6. Buscar estaciones por distrito")
    print("7. Planificar ruta a un punto de interés")
    print("8. Calcular tiempo entre dos estaciones")
    print("9. Salir")
}

func iniciar() {
    while true {
        mostrarMenu()
        let opcion = pedirNumero("Elige una opción: ", minimo: 1, maximo: 9, contexto: "del menú (1 al 9)")

        switch opcion {
        case 1: opcion1VerEstaciones()
        case 2: opcion2BuscarEstacion()
        case 3: opcion3Conexiones()
        case 4: opcion4RutaTransbordo()
        case 5: flujoFiltrarPorEstado()
        case 6: opcion6BuscarDistrito()
        case 7, 8:
            print("\n⚠ Esta opción todavía está en desarrollo.")
        case 9:
            print("\n¡Hasta pronto!")
            return
        default:
            break
        }
    }
}

iniciar()
