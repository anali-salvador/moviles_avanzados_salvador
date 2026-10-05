# PROMPTS – Semana06_03 (rama `ai-assisted`)

Notas del trabajo hecho con IA (Claude Code) para la calculadora de venta a plazos.

---

## 1. Prompt principal (formato CTRFE)

### C – Contexto
Estoy en el proyecto **Semana06_03** (UIKit + Storyboard), en la rama `ai-assisted`.
Ya tengo un `ViewController` vacío en `Main.storyboard`. El estilo visual que quiero
es el de mi lab anterior `apple_lab05_IMC`: título azul centrado, labels y campos de texto con placeholders.

### T – Tarea
Construir una app de **venta a plazos** con dos pantallas:

1. **Nueva Venta** (`ViewController`)
   - Título "Nueva Venta" en azul, centrado.
   - 5 campos (Label + UITextField):
     - Electrodoméstico (texto libre)
     - Precio unitario (S/) (teclado decimal)
     - Cantidad (teclado numérico)
     - Meses (teclado numérico)
     - Tasa interes mensual (%) (teclado decimal)
   - Botón **Calcular**.
   - 5 `@IBOutlet` para los campos.

2. **Resultado** (`ResultadoViewController`)
   - Título "Resultado" en azul, centrado.
   - 6 filas etiqueta + valor: Subtotal, IGV, Monto base, Intereses totales, Total a pagar, Cuota mensual.
   - `var pVenta: VentaModel` y 6 `@IBOutlet` (UILabel) para los valores.
   - En `viewDidLoad` mostrar cada valor con `String(format: "S/. %.2f", ...)`.
   - Botón **Volver** con `popViewController(animated: true)`.
   - Custom Class y Storyboard ID = `ResultadoViewController`.

3. **Modelo** `VentaModel.swift`
   - `class VentaModel: NSObject` con 6 `Double`: `subtotal`, `igv`, `base`, `intereses`, `total`, `cuota`.
   - Un `init()` vacío y un `init` con todos los parámetros.

4. **Navegación**
   - Segue tipo **Show** desde "Calcular" hasta "Resultado", con identifier `showResultado`.
   - En `ViewController`, sobrescribir `prepare(for segue:sender:)`:
     - comprobar que `segue.identifier == "showResultado"`,
     - leer los 5 campos como `Double`,
     - calcular, crear el `VentaModel` y pasarlo a `segue.destination as? ResultadoViewController`.

### R – Restricciones
- Usar **estas fórmulas exactas**:
  ```
  subtotal  = precioUnitario * cantidad
  igv       = subtotal * 0.18
  base      = subtotal + igv
  intereses = base * (tasaInteresMensual / 100) * meses
  total     = base + intereses
  cuota     = total / meses
  ```
- Leer los números de forma segura: aceptar coma o punto decimal, y si el campo está vacío o tiene texto inválido usar 0 (la opción más simple).
- Navegar **por segue** (no por `present`), por eso Volver usa `pop`.
- Compilar con `xcodebuild` (`DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer`) y corregir errores.
- **No hacer commit** hasta que yo lo diga.

### F – Formato
- Mostrar el **diff completo** de los archivos cambiados.
- Mostrar el **resultado de la compilación**.
- Decirme el nombre que usó para la clase de Resultado.

### E – Ejemplo
Con estos datos:

| Campo | Valor |
|---|---|
| Precio unitario | 1500 |
| Cantidad | 2 |
| Meses | 12 |
| Tasa interés mensual | 1.5 |

El resultado esperado es:

| Concepto | Cálculo | Valor |
|---|---|---|
| Subtotal | 1500 × 2 | S/. 3000.00 |
| IGV | 3000 × 0.18 | S/. 540.00 |
| Monto base | 3000 + 540 | S/. 3540.00 |
| Intereses totales | 3540 × 0.015 × 12 | S/. 637.20 |
| Total a pagar | 3540 + 637.20 | S/. 4177.20 |
| Cuota mensual | 4177.20 / 12 | S/. 348.10 |

### Ajustes que pedí después
- **Estilo:** botones azules (`systemBlue`) con texto blanco, `cornerRadius` 10 y ancho completo. Una línea gris antes de "Total a pagar", el total en negrita y la cuota mensual en azul.
- **Layout:** en Nueva Venta, cada label arriba y su campo abajo, a ancho completo. En Resultado, la etiqueta a la izquierda y el valor a la derecha.

---

## 2. Reflexión: IA vs. lo que hice a mano en el Ejercicio 2 (Semana06_02)

**Cómo se pasa a la otra pantalla**
- En Semana06_02 lo hice por código, dentro del botón:
  `instantiateViewController(identifier:)` → asignar `pCliente` → `present(...)`.
- Aquí la IA usó un **segue Show** (`showResultado`) y pasó los datos en **`prepare(for:sender:)`**.
  El botón ya no necesita un `@IBAction`: el storyboard hace la navegación e iOS
  llama a `prepare` justo antes de cambiar de pantalla.
- Ojo: en Semana06_02 tenía **los dos a la vez** (segue + `present`) y se abría la
  pantalla dos veces. Hay que elegir **una sola** forma.

**Agregó un Navigation Controller**
- Yo pedí que "Volver" usara `popViewController`, pero el proyecto no tenía Navigation Controller.
- Sin él, el segue Show se abre como modal y `pop` **no hace nada**.
- La IA lo notó y lo agregó como pantalla inicial. En Semana06_02, como usé `present`,
  "Volver" tenía que usar `dismiss`.
- Regla: `present` → `dismiss` / `push` (o segue Show en un Navigation Controller) → `pop`.

**Validación de los campos**
- En Semana06_02 usé `tfApellido.text!` directamente (con `!`), sin validar nada.
- Aquí yo sí le pedí "manejo seguro de texto inválido o vacío". La IA lo resolvió con una
  función `leerNumero(_:)` que:
  - quita espacios,
  - cambia la coma por punto (`1,5` → `1.5`),
  - devuelve `0` si no se puede convertir (`Double(texto) ?? 0`).
- Así la app no se cae si el usuario deja un campo vacío.

**Evitó dividir entre cero (sin que se lo pidiera)**
- La fórmula dice `cuota = total / meses`. Si Meses está vacío o es 0, en Swift con
  `Double` no da error, pero muestra **"S/. inf"** o **"S/. nan"**.
- La IA usó `let cuota = meses > 0 ? total / meses : 0`.

**Otras cosas que agregó por su cuenta**
- Ocultar el teclado al tocar fuera de los campos, porque el teclado numérico y el decimal no tienen tecla Return.
- Botones de 44 pt de alto, la altura que recomienda Apple, aunque no se lo pedí.
- Usar `systemBlue` y `systemGray4` en vez de colores RGB fijos, para que se adapten al modo oscuro.

**Lo que hay que revisar yo**
- La IA compiló y no hubo errores, pero **la pantalla Resultado no la probó en el simulador**
  (solo vio Nueva Venta). Hay que probar el flujo completo con el ejemplo de arriba.
- Escribió el storyboard editando el XML directamente. Conviene abrirlo en Xcode y
  revisar que se vea bien en el Interface Builder.
