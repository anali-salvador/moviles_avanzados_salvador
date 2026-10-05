import UIKit

// ===== EJERCICIO 6: CARRITO MEJORADO (asistido por IA) =====

// Datos de productos: nombre, precio, cantidad
let productoNombres = ["Laptop", "Mouse", "Teclado", "Monitor", "USB Cable"] // Arreglo con los nombres de los 5 productos
let productoPrecios = [3500.0, 45.50, 120.00, 890.00, 15.00] // Arreglo con el precio unitario de cada producto
let productoCantidades = [1, 3, 1, 1, 5] // Arreglo con la cantidad comprada de cada producto (Mouse y USB con 3+ para probar el descuento)

let codigoCupon = "DESCUENTO20" // Cupón que el cliente ingresó (se compara para saber si aplica el 20% extra)

var subtotalConDescuentosPorCantidad = 0.0 // Acumulador que irá sumando el subtotal de cada producto, ya con su descuento por cantidad aplicado
var huboError = false // Bandera que se activa si se detecta un precio negativo o cantidad en 0

print("===== CARRITO MEJORADO =====") // Encabezado del ticket

for i in 0..<productoNombres.count { // Recorre cada producto por su posición (índice) en los arreglos
    let nombre = productoNombres[i] // Obtiene el nombre del producto actual
    let precio = productoPrecios[i] // Obtiene el precio del producto actual
    let cantidad = productoCantidades[i] // Obtiene la cantidad del producto actual

    // Validación: si el precio es negativo o la cantidad es 0, se marca error y se salta este producto
    if precio < 0 || cantidad == 0 {
        print("ERROR: \(nombre) tiene datos inválidos (precio o cantidad incorrectos)") // Muestra el error específico del producto
        huboError = true // Activa la bandera de error para el resumen final
        continue // Salta a la siguiente vuelta del bucle, sin sumar este producto al subtotal
    }

    var subtotalProducto = precio * Double(cantidad) // Calcula el subtotal normal del producto (precio x cantidad)

    // Descuento por cantidad: si compra 3 o más unidades del mismo producto, se aplica 5% extra SOLO a ese producto
    if cantidad >= 3 {
        let descuentoPorCantidad = subtotalProducto * 0.05 // Calcula el 5% de descuento sobre el subtotal de este producto
        subtotalProducto -= descuentoPorCantidad // Resta ese descuento al subtotal del producto
        print("\(nombre) x\(cantidad): S/. \(subtotalProducto) (incluye 5% desc. por cantidad)") // Muestra el producto indicando que tuvo descuento
    } else {
        print("\(nombre) x\(cantidad): S/. \(subtotalProducto)") // Muestra el producto sin mencionar descuento (no aplicó)
    }

    subtotalConDescuentosPorCantidad += subtotalProducto // Suma el subtotal de este producto (ya con su descuento si tuvo) al acumulador general
}

// Cupón de descuento: si el código ingresado coincide exactamente con "DESCUENTO20", se aplica 20% adicional sobre TODO el total
var totalConCupon = subtotalConDescuentosPorCantidad // Parte del subtotal ya calculado (con descuentos por cantidad incluidos)
if codigoCupon == "DESCUENTO20" { // Compara el cupón ingresado con el código válido
    let descuentoCupon = totalConCupon * 0.20 // Calcula el 20% de descuento sobre el total actual
    totalConCupon -= descuentoCupon // Aplica ese descuento al total
    print("Cupón DESCUENTO20 aplicado: -S/. \(descuentoCupon)") // Informa cuánto se descontó por el cupón
}

// Envío: gratis si el total (ya con descuentos) supera S/. 3000, si no, cuesta S/. 25
var costoEnvio = 0.0 // Variable que guardará el costo del envío (empieza en 0, se define abajo)
if totalConCupon > 3000 { // Compara si el total supera el umbral de envío gratis
    costoEnvio = 0.0 // Si supera 3000, el envío no cuesta nada
    print("Envío GRATIS (compra mayor a S/. 3000)") // Informa que aplicó el envío gratis
} else {
    costoEnvio = 25.0 // Si no supera 3000, el envío cuesta 25 soles
    print("Costo de envío: S/. \(costoEnvio)") // Informa el costo del envío
}

let totalFinalCarrito = totalConCupon + costoEnvio // Suma el total con descuentos más el costo de envío para obtener el total final a pagar

// Puntos de fidelidad: 1 punto por cada S/. 100 gastados (sobre el total final)
let puntosGanados = Int(totalFinalCarrito / 100) // Divide el total final entre 100 y convierte a entero (trunca los puntos parciales)
print("Puntos de fidelidad ganados: \(puntosGanados)") // Muestra cuántos puntos ganó el cliente

print("=============================") // Línea separadora final
print("TOTAL A PAGAR: S/. \(totalFinalCarrito)") // Muestra el monto final que debe pagar el cliente

if huboError { // Verifica si en algún momento se activó la bandera de error
    print("Nota: algunos productos no se incluyeron por datos inválidos.") // Advierte que el carrito no incluyó todos los productos originales
}




// ===== EJERCICIO 7: JUEGO DE ADIVINANZA (asistido por IA) =====

let numeroSecreto = 42 // Define el número que el "jugador" debe adivinar, fijo para esta simulación

// Arreglo con los 5 intentos simulados (en un juego real, estos vendrían de un input del usuario)
let intentosSimulados = [20, 60, 50, 45, 42] // Los intentos van acercándose al número secreto (42) para probar todos los casos

var indiceIntento = 0 // Contador que indica en qué posición del arreglo de intentos vamos (empieza en 0)
var numeroDeIntentos = 0 // Cuenta cuántos intentos se han realizado en total
var adivino = false // Bandera que se activa cuando el jugador acierta el número secreto

print("===== JUEGO DE ADIVINANZA =====") // Encabezado del juego
print("Adivina el número secreto (entre 1 y 100)") // Mensaje de bienvenida al juego

while indiceIntento < intentosSimulados.count && !adivino { // Se repite mientras queden intentos disponibles Y no se haya adivinado
    let intentoActual = intentosSimulados[indiceIntento] // Toma el intento actual del arreglo, según la posición
    numeroDeIntentos += 1 // Suma 1 al contador de intentos realizados

    print("Intento \(numeroDeIntentos): \(intentoActual)") // Muestra qué número se está probando en este intento

    if intentoActual == numeroSecreto { // Compara si el intento actual es EXACTAMENTE igual al número secreto
        print("¡Correcto! Adivinaste el número en \(numeroDeIntentos) intentos.") // Felicita al jugador y muestra cuántos intentos usó
        adivino = true // Activa la bandera para detener el bucle (ya se encontró el número)
    } else if intentoActual > numeroSecreto { // Si el intento es MAYOR que el número secreto
        print("Muy alto") // Indica que el número probado es demasiado grande
    } else { // Si no fue igual ni mayor, entonces necesariamente es menor
        print("Muy bajo") // Indica que el número probado es demasiado pequeño
    }

    indiceIntento += 1 // Avanza a la siguiente posición del arreglo, para probar el siguiente intento en la próxima vuelta
}

// Después del bucle, se verifica si se acabaron los intentos SIN haber adivinado
if !adivino { // Si la bandera "adivino" nunca se activó
    print("Perdiste. El número era: \(numeroSecreto)") // Muestra el mensaje de derrota, revelando el número secreto
}
