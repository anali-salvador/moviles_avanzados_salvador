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





// ===== EJERCICIO 7: INVENTARIO CON MENÚ (asistido por IA) =====

// Estructura simple usando 3 arreglos paralelos para simular productos con nombre, precio y stock
var nombresInv: [String] = ["Laptop", "Mouse", "Teclado", "Monitor", "Audífonos"] // Nombres de los productos
var preciosInv: [Double] = [3500.0, 45.50, 120.0, 890.0, 80.0] // Precio unitario de cada producto
var stockInv: [Int] = [5, 25, 3, 8, 15] // Stock disponible de cada producto

print("===== SISTEMA DE INVENTARIO =====") // Encabezado del sistema

// Función simulada de menú: en un Playground no hay interacción real de menú en bucle infinito,
// así que se simula recorriendo las 5 opciones una por una para demostrar cada funcionalidad.

// Opción 1: Ver inventario completo
print("\n--- OPCIÓN 1: Ver inventario completo ---") // Muestra el título de la opción
for i in 0..<nombresInv.count { // Recorre cada producto por su posición
    print("\(nombresInv[i]) | Precio: S/. \(preciosInv[i]) | Stock: \(stockInv[i])") // Imprime los 3 datos del producto
}

// Opción 2: Buscar un producto específico por nombre
print("\n--- OPCIÓN 2: Buscar producto ---") // Muestra el título de la opción
let productoBuscado = "Teclado" // Nombre del producto que se va a buscar (simulado, sin input real)
if let indice = nombresInv.firstIndex(of: productoBuscado) { // Busca la posición del producto en el arreglo, si existe
    print("Producto encontrado: \(nombresInv[indice]) | Precio: S/. \(preciosInv[indice]) | Stock: \(stockInv[indice])") // Muestra sus datos
} else {
    print("Producto '\(productoBuscado)' no encontrado en el inventario") // Mensaje si no se encuentra
}

// Opción 3: Ver productos con stock bajo (menos de 10 unidades)
print("\n--- OPCIÓN 3: Productos con stock bajo ---") // Muestra el título de la opción
for i in 0..<nombresInv.count { // Recorre cada producto por su posición
    if stockInv[i] < 10 { // Verifica si el stock de este producto es menor a 10
        print("⚠️ \(nombresInv[i]): solo quedan \(stockInv[i]) unidades") // Muestra la alerta de stock bajo
    }
}

// Opción 4: Calcular el valor total del inventario (precio x stock, sumado de todos los productos)
print("\n--- OPCIÓN 4: Valor total del inventario ---") // Muestra el título de la opción
var valorTotalInventario = 0.0 // Acumulador para el valor total
for i in 0..<nombresInv.count { // Recorre cada producto por su posición
    let valorProducto = preciosInv[i] * Double(stockInv[i]) // Calcula el valor de este producto (precio x cantidad en stock)
    valorTotalInventario += valorProducto // Suma ese valor al acumulador total
}
print("Valor total del inventario: S/. \(String(format: "%.2f", valorTotalInventario))") // Muestra el valor total formateado

// Opción 5: Salir (mensaje de cierre del sistema)
print("\n--- OPCIÓN 5: Salir ---") // Muestra el título de la opción
print("Gracias por usar el sistema de inventario. ¡Hasta pronto!") // Mensaje de despedida

print("\n=============================") // Línea separadora final
print("REPORTE FINAL GENERADO CORRECTAMENTE") // Confirmación de que el reporte se completó
