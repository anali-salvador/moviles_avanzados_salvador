import Foundation

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

// 2. Operaciones con Arrays
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




import Foundation

// 1. Declaración de Sets (elementos únicos sin duplicados)
var linea1Transbordos: Set<String> = ["Miguel Grau", "La Cultura", "Gamarra", "Atocongo"]
var linea2Transbordos: Set<String> = ["Miguel Grau", "Óvalo Santa Anita", "Evitamiento", "La Cultura"]

print("--- EJERCICIO SETS ---")

// Insertar un duplicado (Swift lo ignorará automágicamente)
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
