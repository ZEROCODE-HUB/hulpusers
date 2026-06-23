# SPEC UI — REQ-002: Historial de Solicitudes (listado por pestañas)
> Sprint: S 06-2026 · Versión: 1.1 · Estado: **IMPLEMENTADO**
>
> **Changelog:**
> - v1.2 (2026-06-18): §3.1 se añade la **hora de reserva (`hora`) ascendente** como criterio secundario, aplicado tras `fecha` cuando dos solicitudes comparten la misma fecha.
> - v1.1 (2026-06-18): §3 reescrito. El criterio de orden pasa a ser **fecha de reserva del servicio (`fecha`) ascendente** en todas las vistas con filtro y en la búsqueda. La vista **sin filtro** (estado inicial, `seleccion == null`) se ordena por **prioridad de estado** y, dentro de cada grupo, por `fecha` ascendente. Reemplaza el orden por `solicitud_creada_en` DESC de la v1.0.
> - v1.0 (2026-06-18): §3 el listado de la pestaña "Pendiente" (estado `entrantes`) se ordena por `solicitud_creada_en` descendente (la solicitud más reciente primero).

---

## 1. Contexto

`HistorialWidget` (ruta `/historial`, `lib/registro/pages/historial/historial_widget.dart`) muestra al cliente sus solicitudes de servicio leídas desde la vista `vw_solicitudes_servicios_completa`. Los datos se cargan con un `FutureBuilder` + `StreamBuilder` filtrando por `usuario_id == currentUserUid`, y se reparten en pestañas según `_model.seleccion`.

## 2. Pestañas y filtros (lógica existente — sin cambios)

| Pestaña (`_model.seleccion`) | Filtro `estado_solicitud` |
|---|---|
| `Pendiente` | `entrantes` |
| `Activa` | `aceptadas` |
| `En curso` | `iniciadas`, `en camino`, `en proceso` |
| `Finalizado` | `finalizadas`, `reagendadas` |
| `Cancelado` | `canceladas` |

Cuando hay texto de búsqueda (`textController.text != ''`) se devuelve la lista completa sin filtrar por estado (comportamiento existente, sin cambios en el filtrado).

## 3. Ordenamiento del listado

### 3.1 Campo de orden principal

Se usa **`fecha`** (`fecha`, fecha de reserva del servicio) como criterio principal y **`hora`** (`hora`, hora de reserva) como criterio secundario de desempate. La lógica es mostrar primero los servicios que ocurren antes (los más próximos), por lo que ambos van en orden **ascendente**: a igualdad de `fecha`, la solicitud con `hora` más temprana aparece primero.

Manejo de nulos (en todos los casos): los registros con `fecha == null` se ordenan al final; a igualdad de `fecha`, los que tienen `hora == null` se ordenan al final dentro de ese grupo. La comparación de `hora` usa la hora del día (`PostgresTime.time`).

### 3.2 Vista sin filtro (estado inicial, `seleccion == null`)

Al abrir el historial no hay filtro seleccionado. Para mejor experiencia de usuario, la lista se ordena primero por **prioridad de estado** y, dentro de cada grupo, por `fecha` ascendente. La prioridad coloca arriba lo accionable/próximo y abajo lo ya cerrado:

| Prioridad | Estado(s) |
|---|---|
| 0 | `entrantes` (pendientes de respuesta) |
| 1 | `aceptadas` |
| 2 | `iniciadas`, `en camino`, `en proceso` (en curso) |
| 3 | `finalizadas`, `reagendadas` |
| 4 | `canceladas` |
| 5 | cualquier otro / desconocido |

### 3.3 Vistas con filtro y búsqueda

Cada pestaña (`Pendiente`, `Activa`, `En curso`, `Finalizado`, `Cancelado`) y la búsqueda por texto ordenan su resultado por `fecha` ascendente. No se aplica prioridad de estado dentro de una pestaña (todos comparten estado o intención).

### 3.4 Alcance

Solo cambia el orden de presentación en `HistorialWidget`. No se modifican los filtros, la consulta a Supabase, ni ninguna otra lógica de negocio.
