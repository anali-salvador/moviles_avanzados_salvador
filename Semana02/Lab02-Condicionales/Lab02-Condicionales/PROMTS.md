# Prompts utilizados — Laboratorio 02

## Herramienta de IA utilizada
Claude (Anthropic)

## Ejercicio 6 — Carrito mejorado

### Prompt (estructura CTRFE):
CONTEXTO: Soy estudiante de Programación en Móviles Avanzado, aprendiendo Swift con condicionales, switch y bucles.
TAREA: Mejora mi carrito de compras agregando: descuento del 5% extra si se compran 3 o más unidades de un producto, un cupón "DESCUENTO20" que aplique 20% adicional al total, envío gratis si el total supera S/. 3000 (si no, S/. 25), puntos de fidelidad (1 punto por cada S/. 100 gastados), y validación de errores si el precio es negativo o la cantidad es 0.
RESTRICCIONES: Solo puedo usar lo visto en clase (if/else, switch, for-in, while). Cada línea del código debe tener un comentario específico explicando qué hace, no comentarios genéricos.
FORMATO: Código Swift comentado línea por línea, listo para pegar en un Playground.
EJEMPLO: Un comentario bueno explica el propósito ("Calcula el 5% de descuento sobre el subtotal de este producto"), no algo vago como "hace un cálculo".

### ¿Funcionó a la primera?
Sí, el código corrió sin errores desde el primer intento.

### ¿La IA usó algo que no conocías?
Sí — usó la palabra clave `continue` dentro de un bucle for, que permite saltar directamente a la siguiente iteración sin ejecutar el resto del código de esa vuelta. Investigué que sirve para "saltarse" casos inválidos sin detener todo el bucle.

## Ejercicio 7 — Juego de adivinanza

### Prompt (estructura CTRFE):
CONTEXTO: Mismo curso, ya completé el carrito de compras con condicionales y bucles.
TAREA: Genera un mini juego de adivinanza de números en un Playground: un número secreto fijo (ejemplo 42), simular 5 intentos con variables (no puedo usar input real en Playground), usar un bucle while para recorrer los intentos, mostrar en cada intento si es "Muy alto", "Muy bajo" o "¡Correcto!", contar cuántos intentos necesitó, y si no adivina en 5 intentos, mostrar "Perdiste. El número era: X".
RESTRICCIONES: Comentar cada línea del código, explicando específicamente la lógica de comparación (por qué usa >, <, ==).
FORMATO: Código Swift comentado, con un arreglo de intentos simulados en vez de pedir input real.
EJEMPLO: Los intentos deben ir acercándose al número secreto para poder probar los tres casos (muy alto, muy bajo, correcto).

### ¿Funcionó a la primera?
Sí, sin errores.

### ¿La IA usó algo que no conocías?
Sí — usó una condición doble en el while (`indiceIntento < intentosSimulados.count && !adivino`), combinando dos condiciones con && para que el bucle se detenga por dos motivos distintos (se acaban los intentos, o ya se adivinó). No conocía esa forma de combinar condiciones de salida en un mismo while.
