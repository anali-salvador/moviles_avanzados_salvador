# PROMPTS.md - Caso A Ventas

Cada consulta a la IA se anota con este formato: Contexto, Tarea, Restricciones, Formato esperado y qué hicimos con la respuesta.

## Consulta 1: borrador del expediente
- Contexto: Laboratorio 11 de Móviles Avanzado, Caso A (Ventas, UIKit y Core Data).
- Tarea: armar un borrador del expediente con las 9 secciones del anexo.
- Restricciones: de 2 a 3 páginas, frases cortas, sin código y sin crear el proyecto.
- Formato esperado: documento Word con tablas y un dibujo del modelo.
- Qué hicimos con la respuesta: Se aceptó la respuesta y se compiló sin errores.

Prueba en el simulador: (completar)

## Consulta 2: modelo de datos
- Contexto: proyecto apple_semana12_Ventas en UIKit con Core Data, recién creado.
- Tarea: definir las entidades Usuario, Producto, Cliente y Venta con sus atributos y relaciones.
- Restricciones: cada venta tiene un vendedor, un producto y un cliente. Usuario, Producto y Cliente usan delete rule Deny. Venta usa Nullify. No tocar el storyboard.
- Formato esperado: archivo .xcdatamodeld con 4 entidades y Codegen Class Definition.
- Qué hicimos con la respuesta: Se aceptó la respuesta y se compiló sin errores.

Prueba en el simulador: (completar)

## Consulta 3: registro, login y sesión
- Contexto: el modelo de datos ya existe. La app debe abrir en el login.
- Tarea: crear las pantallas de registro y login, y una sesión para guardar al usuario que ingresa.
- Restricciones: usuario único sin distinguir mayúsculas. Clave de mínimo 6 caracteres. Mensaje genérico "Usuario o clave incorrectos". Sesión como singleton. Pantallas por código.
- Formato esperado: Sesion.swift, LoginViewController y RegistroViewController en UIKit.
- Qué hicimos con la respuesta: Se aceptó la respuesta y se compiló sin errores.

Prueba en el simulador: (completar)

## Consulta 4: pestañas por rol y pantalla Cuenta
- Contexto: el login ya guarda al usuario en la sesión.
- Tarea: mostrar pestañas según el rol y una pantalla Cuenta para cerrar sesión.
- Restricciones: Vendedor ve Productos, Clientes, Venta, Mis ventas y Cuenta. Supervisor ve Resumen, Ventas, Productos, Clientes y Cuenta. Cada pestaña con su ícono.
- Formato esperado: un UITabBarController armado por código.
- Qué hicimos con la respuesta: Se aceptó la respuesta y se compiló sin errores.

Prueba en el simulador: (completar)

## Consulta 5: pantalla de productos
- Contexto: el Supervisor administra el catálogo y el Vendedor solo lo consulta.
- Tarea: listar productos con búsqueda por nombre y filtro por categoría.
- Restricciones: stock en color (verde, ámbar y rojo). Solo el Supervisor crea, edita y borra. No se borra un producto que tiene ventas.
- Formato esperado: tabla con NSFetchRequest, NSPredicate y orden por nombre.
- Qué hicimos con la respuesta: Se aceptó la respuesta y se compiló sin errores.

Prueba en el simulador: (completar)

## Consulta 6: pantalla de clientes
- Contexto: Vendedor y Supervisor registran clientes.
- Tarea: listar clientes con búsqueda por nombre o documento, y su categoría y total comprado.
- Restricciones: categoría y total se calculan con las ventas no anuladas y no se guardan. Regular, Frecuente desde S/ 1000 y VIP desde S/ 5000. Solo el Supervisor borra.
- Formato esperado: tabla y una extensión de Cliente con las funciones de cálculo.
- Qué hicimos con la respuesta: Se aceptó la respuesta y se compiló sin errores.

Prueba en el simulador: (completar)

## Consulta 7: nueva venta
- Contexto: el Vendedor registra ventas a su nombre.
- Tarea: elegir cliente, producto y cantidad, y calcular el resumen de la venta.
- Restricciones: descuento de 10% solo para clientes VIP. IGV de 18% sobre el subtotal menos el descuento. Redondeo a 2 decimales. Si no hay stock, alerta "Stock insuficiente" y no se registra nada.
- Formato esperado: pantalla por código y un cálculo separado que se pueda probar.
- Qué hicimos con la respuesta: Se aceptó la respuesta y se compiló sin errores.

Prueba en el simulador: (completar)

## Consulta 8: mis ventas
- Contexto: el Vendedor quiere ver lo que vendió.
- Tarea: listar sus ventas con filtro Todas, Hoy y Mes, y búsqueda por cliente.
- Restricciones: solo aparecen las ventas del vendedor de la sesión. Los indicadores Hoy y Mes no cuentan ventas anuladas. El vendedor no puede anular.
- Formato esperado: tabla con NSCompoundPredicate y orden por fecha.
- Qué hicimos con la respuesta: Se aceptó la respuesta y se compiló sin errores.

Prueba en el simulador: (completar)

## Consulta 9: ventas del equipo y anular
- Contexto: el Supervisor revisa las ventas de todo el equipo.
- Tarea: listar todas las ventas con filtro por vendedor y permitir anular una venta.
- Restricciones: anular pide un motivo obligatorio. Al anular se devuelve el stock. Una venta anulada no se puede anular otra vez.
- Formato esperado: tabla con acción de deslizar y una alerta con campo de texto.
- Qué hicimos con la respuesta: Se aceptó la respuesta y se compiló sin errores.

Prueba en el simulador: (completar)

## Consulta 10: resumen del supervisor
- Contexto: el Supervisor necesita una vista rápida del negocio.
- Tarea: mostrar indicadores, un gráfico de los últimos 7 días, el ranking de vendedores y los productos con stock bajo.
- Restricciones: solo ventas no anuladas. Rangos de fecha con Calendar. Gráfico hecho con vistas, sin librerías.
- Formato esperado: pantalla con scroll y tarjetas.
- Qué hicimos con la respuesta: Se aceptó la respuesta y se compiló sin errores.

Prueba en el simulador: (completar)

## Consulta 11: ícono y nombre de la app
- Contexto: la app tenía el ícono vacío y un nombre largo.
- Tarea: crear un ícono y poner "Ventas" como nombre bajo el ícono.
- Restricciones: PNG de 1024 x 1024 sin transparencia, sin esquinas redondeadas y sin texto.
- Formato esperado: imagen en AppIcon.appiconset y Display Name en el proyecto.
- Qué hicimos con la respuesta: Se aceptó la respuesta y se compiló sin errores.

Prueba en el simulador: (completar)

## Consulta 12: ajustes según la maqueta
- Contexto: las pantallas ya funcionaban, pero no se parecían a la maqueta del enunciado.
- Tarea: ajustar login, registro, productos, clientes, nueva venta, mis ventas, ventas del equipo y resumen.
- Restricciones: solo cambia lo visual. La lógica, los filtros y los permisos no cambian. Sin librerías.
- Formato esperado: las mismas pantallas con tarjetas, píldoras de color e iniciales.
- Qué hicimos con la respuesta: Se aceptó la respuesta y se compiló sin errores.

Prueba en el simulador: (completar)

## Consulta 13: ícono con carrito, ramas y PROMPTS.md final
- Contexto: el proyecto está terminado en la rama manual.
- Tarea: cambiar el ícono por un carrito, pasar el proyecto a ia-asistida y a main, y completar este archivo.
- Restricciones: ícono con el mismo azul del login. Merges sin conflictos. Commits sin mencionar a la IA.
- Formato esperado: ramas manual, ia-asistida y main subidas al repositorio.
- Qué hicimos con la respuesta: Se aceptó la respuesta y se compiló sin errores.

Prueba en el simulador: (completar)
