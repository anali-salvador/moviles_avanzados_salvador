// ===== CASO 2 — PARTE B: BIBLIOTECA (CON IA) =====
// Docente: Juan León

enum EstadoLibro { // Define los dos estados posibles de un libro
    case disponible, prestado // disponible: se puede prestar; prestado: alguien lo tiene
} // Fin del enum EstadoLibro

struct Libro { // Modelo de datos de un libro (tipo por valor)
    let titulo: String // Título del libro, constante porque no cambia
    let autor: String // Autor del libro, constante porque no cambia
    var estado: EstadoLibro // Estado actual; var porque cambia al prestar/devolver (sin valor por defecto, se pasa al crear)
} // Fin del struct Libro

class Biblioteca { // Clase que gestiona la colección de libros y sus operaciones
    var libros: [Libro] = [] // Lista de libros registrados, empieza vacía

    func agregar(libro: Libro) { // Registra un libro nuevo en la biblioteca
        libros.append(libro) // Añade el libro al final del array
    } // Fin de agregar

    func prestar(titulo: String) -> Bool { // Intenta prestar un libro; devuelve true si se pudo
        for i in 0..<libros.count { // Recorre por índice para poder modificar el struct dentro del array
            if libros[i].titulo == titulo { // Comprueba si este es el libro buscado
                if libros[i].estado == .disponible { // Solo se presta si está disponible
                    libros[i].estado = .prestado // Cambia el estado a prestado directamente en el array
                    print("Préstamo aprobado: \(titulo)") // Informa que el préstamo fue exitoso
                    return true // Termina indicando que el préstamo se realizó
                } else { // El libro existe pero ya está prestado
                    print("Error: \(titulo) ya está prestado") // Informa el motivo del rechazo
                    return false // Termina indicando que el préstamo fue rechazado
                } // Fin de la verificación de estado
            } // Fin de la comparación de título
        } // Fin del recorrido de libros
        print("Error: no existe \(titulo)") // Se recorrió todo el array sin encontrar el título
        return false // No se pudo prestar porque el libro no existe
    } // Fin de prestar

    func devolver(titulo: String) -> Bool { // Intenta devolver un libro; devuelve true si se pudo
        for i in 0..<libros.count { // Recorre por índice para poder modificar el struct dentro del array
            if libros[i].titulo == titulo { // Comprueba si este es el libro buscado
                if libros[i].estado == .prestado { // Solo se devuelve si estaba prestado
                    libros[i].estado = .disponible // Cambia el estado a disponible otra vez
                    print("Devolución registrada: \(titulo)") // Informa que la devolución fue exitosa
                    return true // Termina indicando que la devolución se realizó
                } else { // El libro existe pero no estaba prestado
                    print("Error: \(titulo) ya estaba disponible") // Informa el motivo del rechazo
                    return false // Termina indicando que la devolución fue rechazada
                } // Fin de la verificación de estado
            } // Fin de la comparación de título
        } // Fin del recorrido de libros
        print("Error: no existe \(titulo)") // Se recorrió todo el array sin encontrar el título
        return false // No se pudo devolver porque el libro no existe
    } // Fin de devolver

    func inventario() { // Muestra todos los libros con su estado actual
        print("===== INVENTARIO =====") // Imprime el encabezado del reporte
        for libro in libros { // Recorre cada libro (solo lectura, no hace falta índice)
            switch libro.estado { // switch exhaustivo sobre el enum: cubre todos los casos
            case .disponible: // Caso en que el libro está disponible
                print("\(libro.titulo) (\(libro.autor)) - disponible") // Imprime título, autor y estado disponible
            case .prestado: // Caso en que el libro está prestado
                print("\(libro.titulo) (\(libro.autor)) - prestado") // Imprime título, autor y estado prestado
            } // Fin del switch
        } // Fin del recorrido de libros
    } // Fin de inventario
} // Fin de la clase Biblioteca

// Simulación
let biblioteca = Biblioteca() // Crea una biblioteca vacía
biblioteca.agregar(libro: Libro(titulo: "Cien años de soledad", autor: "Gabriel García Márquez", estado: .disponible)) // Registra el libro 1 como disponible
biblioteca.agregar(libro: Libro(titulo: "La ciudad y los perros", autor: "Mario Vargas Llosa", estado: .disponible)) // Registra el libro 2 como disponible
biblioteca.agregar(libro: Libro(titulo: "El Quijote", autor: "Miguel de Cervantes", estado: .disponible)) // Registra el libro 3 como disponible

_ = biblioteca.prestar(titulo: "La ciudad y los perros") // Primer préstamo: se aprueba
_ = biblioteca.prestar(titulo: "La ciudad y los perros") // Segundo préstamo del mismo libro: error, ya está prestado
_ = biblioteca.devolver(titulo: "La ciudad y los perros") // Se devuelve: vuelve a estar disponible
_ = biblioteca.prestar(titulo: "El Quijote") // Préstamo aprobado de El Quijote
_ = biblioteca.prestar(titulo: "El Principito") // Error: el libro no existe en la biblioteca
biblioteca.inventario() // Muestra el estado final de todos los libros
