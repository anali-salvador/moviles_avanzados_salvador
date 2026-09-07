import UIKit

// ===== EJERCICIO 6: GESTIÓN DE NOTAS (asistido por IA) =====

// Diccionario donde cada alumno (clave) tiene un arreglo de 3 notas (valor)
var alumnosNotas: [String: [Double]] = [
    "Ana García": [15.0, 17.0, 14.0],       // 3 notas del alumno Ana
    "Luis Torres": [10.0, 12.0, 11.0],      // 3 notas del alumno Luis
    "Carla Ruiz": [18.0, 19.0, 20.0],       // 3 notas del alumno Carla
    "Pedro Vega": [13.0, 13.0, 12.0],       // 3 notas del alumno Pedro
    "María López": [16.0, 15.0, 17.0]       // 3 notas del alumno María
]

print("===== SISTEMA DE GESTIÓN DE NOTAS =====") // Encabezado del reporte

var promedios: [String: Double] = [:] // Diccionario que guardará el promedio calculado de cada alumno

// Recorre cada alumno del diccionario original para calcular su promedio
for (nombre, notas) in alumnosNotas { // 'nombre' es la clave (String), 'notas' es el valor (arreglo de Double)
    var sumaNotas = 0.0 // Acumulador que sumará las 3 notas de este alumno
    for nota in notas { // Recorre cada nota dentro del arreglo del alumno actual
        sumaNotas += nota // Suma la nota actual al acumulador
    }
    let promedio = sumaNotas / Double(notas.count) // Divide la suma entre la cantidad de notas para obtener el promedio
    promedios[nombre] = promedio // Guarda el promedio calculado en el diccionario de promedios, usando el mismo nombre como clave
}

print("\n--- Promedios individuales ---") // Subtítulo de la sección
for (nombre, promedio) in promedios { // Recorre el diccionario de promedios ya calculados
    var clasificacion = "" // Variable que guardará el texto de la categoría del alumno

    // Clasifica el promedio en una categoría usando switch con rangos
    switch promedio {
    case 18...20: clasificacion = "Excelente" // Rango de notas excelentes
    case 14..<18: clasificacion = "Bueno" // Rango de notas buenas
    case 11..<14: clasificacion = "Aprobado" // Rango de notas aprobadas
    default: clasificacion = "Desaprobado" // Cualquier promedio menor a 11
    }

    let promedioTexto = String(format: "%.2f", promedio) // Formatea el promedio a 2 decimales para mostrarlo ordenado
    print("\(nombre): \(promedioTexto) - \(clasificacion)") // Imprime el nombre, su promedio y su categoría
}

// --- Estadísticas generales ---
print("\n--- Estadísticas del curso ---") // Subtítulo de la sección de estadísticas

var sumaPromedios = 0.0 // Acumulador para sumar todos los promedios individuales
var notaMasAlta = 0.0 // Guardará el promedio más alto encontrado
var notaMasBaja = 20.0 // Guardará el promedio más bajo encontrado (empieza en 20, el máximo posible)
var nombreNotaAlta = "" // Guardará el nombre del alumno con la nota más alta
var nombreNotaBaja = "" // Guardará el nombre del alumno con la nota más baja
var cantidadAprobados = 0 // Contador de cuántos alumnos tienen promedio >= 11 (aprobados)

for (nombre, promedio) in promedios { // Recorre de nuevo el diccionario de promedios para las estadísticas
    sumaPromedios += promedio // Suma este promedio al acumulador general

    if promedio > notaMasAlta { // Compara si este promedio es mayor al máximo registrado hasta ahora
        notaMasAlta = promedio // Actualiza el máximo
        nombreNotaAlta = nombre // Guarda el nombre de quien tiene ese máximo
    }
    if promedio < notaMasBaja { // Compara si este promedio es menor al mínimo registrado hasta ahora
        notaMasBaja = promedio // Actualiza el mínimo
        nombreNotaBaja = nombre // Guarda el nombre de quien tiene ese mínimo
    }
    if promedio >= 11 { // Verifica si el alumno está aprobado (promedio 11 o más)
        cantidadAprobados += 1 // Suma 1 al contador de aprobados
    }
}

let promedioGeneral = sumaPromedios / Double(promedios.count) // Calcula el promedio general dividiendo la suma entre la cantidad de alumnos
let porcentajeAprobados = (Double(cantidadAprobados) / Double(promedios.count)) * 100 // Calcula qué porcentaje de alumnos aprobó

print("Promedio general del curso: \(String(format: "%.2f", promedioGeneral))") // Muestra el promedio general formateado
print("Nota más alta: \(nombreNotaAlta) con \(String(format: "%.2f", notaMasAlta))") // Muestra quién tiene la nota más alta
print("Nota más baja: \(nombreNotaBaja) con \(String(format: "%.2f", notaMasBaja))") // Muestra quién tiene la nota más baja
print("Porcentaje de aprobados: \(String(format: "%.1f", porcentajeAprobados))%") // Muestra el porcentaje de aprobados

// --- Ordenar por promedio ---
print("\n--- Ranking de alumnos (mayor a menor) ---") // Subtítulo del ranking

// Convierte el diccionario en un arreglo de tuplas (nombre, promedio) para poder ordenarlo
let ranking = promedios.sorted { $0.value > $1.value } // Ordena de mayor a menor promedio (value)

for (posicion, alumno) in ranking.enumerated() { // Recorre el arreglo ya ordenado, con su posición (índice)
    let promedioTexto = String(format: "%.2f", alumno.value) // Formatea el promedio de este alumno a 2 decimales
    print("\(posicion + 1). \(alumno.key) - \(promedioTexto)") // Imprime la posición en el ranking, el nombre y el promedio
}
