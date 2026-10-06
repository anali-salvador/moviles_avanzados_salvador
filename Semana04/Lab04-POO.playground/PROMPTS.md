# Prompts utilizados — Laboratorio 04

## Herramienta de IA utilizada
Claude (Anthropic)

## Caso 2B — Biblioteca

### Prompt 1:
```
CONTEXTO: Soy estudiante de Swift, cuarta semana, trabajo en un Playground de Xcode.
TAREA: Necesito una biblioteca con enum EstadoLibro, struct Libro y class Biblioteca con prestar, devolver e inventario.
RESTRICCIONES: Solo struct, class, herencia, protocolos, enums, arrays, bucles y funciones. Sin optionals ni guard let, sin firstIndex(where:), sin didSet, sin propiedades calculadas, sin genéricos.
FORMATO: Solo el código Swift, con las firmas exactas que te indico.
```

EJEMPLO:
```
Préstamo aprobado: La ciudad y los perros
Error: La ciudad y los perros ya está prestado
Devolución registrada: La ciudad y los perros
Préstamo aprobado: El Quijote
Error: no existe El Principito
===== INVENTARIO =====
Cien años de soledad (Gabriel García Márquez) - disponible
La ciudad y los perros (Mario Vargas Llosa) - disponible
El Quijote (Miguel de Cervantes) - prestado
```

### Respuesta de la IA:
Generó el enum EstadoLibro, el struct Libro y la class Biblioteca completos, con los métodos prestar, devolver e inventario usando un bucle for con índice (for i in 0..<libros.count), tal como pedían las restricciones.

### ¿Funcionó a la primera?
Sí. El código compiló sin errores y la salida coincidió exactamente con la esperada desde el primer intento.

### ¿Usó algo que no hemos visto en clase?
No. Respetó las restricciones: no usó firstIndex(where:), optionals, guard let, didSet, propiedades calculadas ni genéricos.

## Mi versión (Parte A) vs. la versión de la IA (Parte B)

### ¿Qué hizo distinto la IA respecto a mi solución?
La estructura es prácticamente igual (mismo enum, mismo struct, misma clase con bucle por índice). La diferencia es que en la Parte B, el struct Libro no tiene valor por defecto para estado, así que hay que indicarlo explícitamente al crear cada libro (estado: .disponible). También cambia el mensaje de error al devolver un libro que no estaba prestado ("ya estaba disponible" en vez de "no estaba prestado"), aunque la simulación nunca llega a probar ese caso.

### ¿Hay alguna línea de la IA que no entiendo del todo? ¿Cuál?
No, el código es muy similar a mi propia solución manual, así que no hubo líneas difíciles de entender.

### ¿Qué me pareció mejor de MI versión?
Que el struct Libro tiene un valor por defecto (estado = .disponible), así que al crear un libro nuevo no hay que escribirlo cada vez.

### ¿Qué me pareció mejor de la versión de la IA?
El mensaje de error al devolver un libro ("ya estaba disponible") es un poco más claro que el mío, porque explica justo por qué no se pudo hacer la devolución.
