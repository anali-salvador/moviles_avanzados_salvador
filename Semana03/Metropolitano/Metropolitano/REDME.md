# Simulador de Información del Metro de Lima

Simulador en consola (Swift) del sistema de Metro de Lima, construido
con colecciones (diccionarios y arreglos).

## Cómo ejecutar

```bash
swift a.swift
```

## Requerimientos Funcionales

**RF01 — Opción 1 del menú: Listar estaciones por línea**
El sistema permite elegir una línea del Metro de Lima y muestra todas sus estaciones en orden, junto con su origen, destino y estado actual.

**RF02 — Opción 2 del menú: Buscar estación**
El sistema permite buscar una estación por su nombre, sin importar mayúsculas o tildes, y muestra su línea, distrito y las estaciones cercanas dentro del mismo distrito.

**RF03 — Opción 7 del menú: Planificar ruta a un punto de interés**
El sistema permite indicar la zona donde se encuentra el usuario y un punto de interés como destino, sugiriendo la estación más cercana y la ruta a seguir.

**RF04 — Opción 9 del menú: Información general de una línea**
El sistema permite elegir una línea y muestra su origen, destino, cantidad de estaciones, estado y los distritos que atraviesa.

**RF05 — Validación general del sistema**
En todo el menú, el sistema valida que el usuario ingrese datos correctos según lo solicitado (número o texto), mostrando avisos claros sin cerrarse ante errores.
