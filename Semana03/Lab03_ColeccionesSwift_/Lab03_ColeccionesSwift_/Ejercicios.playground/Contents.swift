import Foundation

// Desarrollado por: Anali Salvador

// ===== EJERCICIO 1: ARRAYS =====

// 1. Declaración de un Array ordenado con la secuencia de estaciones de la Línea 1
var estacionLinea1: [String] = [
    "Villa El Salvador",
    "Parque Industrial",
    "Pumacahua",
    "Villa María",
    "Miguel Grau",
    "Gamarra",
    "La Cultura"
]

print("--- EJERCICIO ARRAYS ---")

// Agregar una nueva estación al final
estacionLinea1.append("Arriola")

// Acceder a la primera y última estación
if let primera = estacionLinea1.first, let ultima = estacionLinea1.last {
    print("Primera estación: \(primera)")
    print("Última estación: \(ultima)")
}

// Recorrer la lista con su índice
print("\nListado de estaciones ordenadas:")
for (index, estacion) in estacionLinea1.enumerated() {
    print("Estación \(index + 1): \(estacion)")
}

// ===== FIX: 3 errores =====

// FIX 1: no se puede agregar un Int (7) a un array declarado como [String]
var frutas = ["Manzana", "Plátano", "Naranja"]
frutas.append("Uva") // Corregido: se agrega un String válido, no un número

// FIX 2: 'colores' se declaró con let, no se puede modificar con append
var colores = ["Rojo", "Azul", "Verde"] // Corregido: se cambió let por var
colores.append("Amarillo")

// FIX 3: el array 'numeros' solo tiene 5 elementos (índices 0 al 4), el índice 5 no existe
let numeros = [10, 20, 30, 40, 50]
print(numeros[4]) // Corregido: se accede al último índice válido (4), no al 5

// PREDICT: ¿Qué imprime este código?
let vagones = ["A", "B", "C"]
print(vagones.count) // PREDICT: 3
// El .count devuelve la cantidad de elementos del array, no el último índice


// ===== EJERCICIO 2: DICCIONARIOS =====

// 1. Declaración de un Diccionario [Clave: Valor] con información detallada por estación
var mapaEstaciones: [String: [String: Any]] = [
    "La Cultura": [
        "distrito": "San Borja",
        "tiempoHaciaGrauMin": 12,
        "tieneAscensor": true
    ],
    "Gamarra": [
        "distrito": "La Victoria",
        "tiempoHaciaGrauMin": 5,
        "tieneAscensor": false
    ],
    "Miguel Grau": [
        "distrito": "Cercado de Lima",
        "tiempoHaciaGrauMin": 0,
        "tieneAscensor": true
    ]
]

print("\n--- EJERCICIO DICCIONARIOS ---")

// Agregar una nueva estación al diccionario
mapaEstaciones["Angamos"] = [
    "distrito": "Surquillo",
    "tiempoHaciaGrauMin": 18,
    "tieneAscensor": true
]

// Consultar datos de una estación en específico
let nombreEstacion = "La Cultura"
if let datos = mapaEstaciones[nombreEstacion] {
    print("Información de la estación '\(nombreEstacion)':")
    print("Distrito: \(datos["distrito"] ?? "Desconocido")")
    print("Tiempo a Grau: \(datos["tiempoHaciaGrauMin"] ?? 0) min")
}

// Recorrer el diccionario completo
print("\nResumen general de estaciones:")
for (estacion, detalles) in mapaEstaciones {
    let distrito = detalles["distrito"] as? String ?? "N/A"
    print("• \(estacion) - Ubicada en: \(distrito)")
}

// ANALYZE: ¿Por qué se usa [String: Any] y no [String: String]?
// Porque cada estación tiene datos de DISTINTOS tipos: el distrito es String,
// el tiempo es Int, y si tiene ascensor es Bool. "Any" permite guardar
// cualquier tipo de dato dentro del mismo diccionario. La desventaja es
// que hay que convertir el tipo (as? String, as? Int) cada vez que se usa.


// ===== EJERCICIO 3: SETS =====

// 1. Declaración de Sets (elementos únicos sin duplicados)
var linea1Transbordos: Set<String> = ["Miguel Grau", "La Cultura", "Gamarra", "Atocongo"]
var linea2Transbordos: Set<String> = ["Miguel Grau", "Óvalo Santa Anita", "Evitamiento", "La Cultura"]

print("\n--- EJERCICIO SETS ---")

// Insertar un duplicado (Swift lo ignorará automáticamente)
linea1Transbordos.insert("La Cultura")

// Intersección: Encontrar estaciones donde se cruzan o conectan ambas líneas
let estacionesConexion = linea1Transbordos.intersection(linea2Transbordos)
print("Estaciones de conexión entre Línea 1 y Línea 2:")
for estacion in estacionesConexion {
    print("- \(estacion)")
}

// Unión: Obtener la lista total de puntos clave sin repetir ninguno
let totalEstacionesClave = linea1Transbordos.union(linea2Transbordos)
print("\nTotal de estaciones clave únicas (\(totalEstacionesClave.count) en total):")
print(totalEstacionesClave)

// PREDICT: ¿Cuántos elementos tendrá este Set después de insertar duplicados?
var pruebaSet: Set<Int> = [1, 2, 3]
pruebaSet.insert(2)
pruebaSet.insert(4)
print(pruebaSet.count) // PREDICT: 4
// Aunque se insertó el 2 dos veces, un Set nunca guarda valores repetidos,
// por eso el conteo final es 4 (1, 2, 3, 4), no 5.






// ===== EJERCICIO 4: COMBINACIÓN DE COLECCIONES =====

print("\n--- EJERCICIO 4: INVENTARIO DE PRODUCTOS ---")

// TODO 10: Inventario de productos usando Array + Diccionario combinados
var nombresProductos: [String] = ["Laptop", "Mouse", "Teclado", "Monitor"]
var inventario: [String: Int] = [
    "Laptop": 5,
    "Mouse": 20,
    "Teclado": 15,
    "Monitor": 8
]

// Recorre la lista de nombres (Array) y consulta el stock de cada uno (Dictionary)
for producto in nombresProductos {
    if let stock = inventario[producto] {
        if stock < 10 {
            print("⚠️ \(producto): \(stock) unidades (STOCK BAJO)")
        } else {
            print("✅ \(producto): \(stock) unidades")
        }
    }
}

// Agregar un producto nuevo a ambas colecciones
nombresProductos.append("Audífonos")
inventario["Audífonos"] = 3

print("\nInventario actualizado:")
for producto in nombresProductos {
    if let stock = inventario[producto] {
        print("\(producto): \(stock) unidades")
    }
}
