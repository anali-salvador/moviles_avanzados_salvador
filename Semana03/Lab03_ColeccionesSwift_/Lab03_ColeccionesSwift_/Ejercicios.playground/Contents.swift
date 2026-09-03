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
