# SPEC UI — REQ-001: Formulario de Reserva y Pantalla de Éxito
> Sprint: S 05-2026 · Versión: 1.3 · Estado: **IMPLEMENTADO**
> Referencia visual: mockup adjunto (imagen entregada el 2026-06-10)
>
> **Changelog:**
> - v1.3 (2026-06-13): §3.4 Ciudad → carga dinámica desde backend. §6.1 → ciudad_id añadido al insert. §6.4 resuelto con migración 0001_geo_tables.sql.

---

## Decisión de arquitectura: deprecación del flujo IA

### Contexto
El mecanismo original de creación de servicios utilizaba un chat con IA (`ChatiaWidget` / ruta `/chatia`) como punto de entrada. El usuario describía libremente el servicio que quería y la IA interpretaba la solicitud.

### Decisión (2026-06-10)
**El flujo de IA queda retirado/deprecado del flujo del cliente.** En su reemplazo se integra un formulario estructurado (`ServiceBookingFormPage`) que garantiza datos completos y validados desde el primer paso.

| | Flujo anterior (deprecado) | Flujo actual |
|---|---|---|
| **Componente** | `ChatiaWidget` | `ServiceBookingFormPage` |
| **Ruta** | `/chatia` | `/serviceBookingForm` |
| **Entrada** | Texto libre al chat IA | Formulario estructurado |
| **Estado** | ⛔ Deprecado — sin tráfico de cliente | ✅ Activo |

### Puntos de entrada reemplazados
Los siguientes tres lugares del código navegan ahora a `ServiceBookingFormPage` en lugar de `ChatiaWidget`:

- `detalles_widget.dart` — botón "Agendar" en la pantalla de detalle de servicio
- `servicios_widget.dart` — botón de agendamiento en el listado de servicios por categoría
- `busquedas_widget.dart` — botón de agendamiento en resultados de búsqueda

### Estado del código `ChatiaWidget`
`ChatiaWidget` y sus archivos asociados (`chatia_widget.dart`, `chatia_model.dart`) se conservan en el repositorio pero **no reciben tráfico**. No se eliminan para preservar historial. Si en el futuro se requiere un flujo asistido por IA, se construirá sobre esta base o sobre una nueva pantalla.

---

## Índice
1. [Tokens de diseño globales](#1-tokens-de-diseño-globales)
2. [Componentes reutilizables](#2-componentes-reutilizables)
3. [Pantalla 1 — ServiceBookingFormPage](#3-pantalla-1--servicebookingformpage)
4. [Pantalla 2 — BookingSuccessPage](#4-pantalla-2--bookingsuccesspage)
5. [Comportamientos e interacciones](#5-comportamientos-e-interacciones)
6. [Persistencia en Supabase](#6-persistencia-en-supabase)
7. [Cambios al SPEC funcional originados en el diseño](#7-cambios-al-spec-funcional-originados-en-el-diseño)

---

## 1. Tokens de diseño globales

### 1.1 Paleta de colores

| Token | Hex | Uso |
|---|---|---|
| `colorPrimary` | `#1A3C2E` | Botones principales, borde selected, íconos activos |
| `colorPrimaryLight` | `#E8F5EE` | Fondo chip seleccionado, fondo tarjeta éxito |
| `colorAccent` | `#2D8653` | Precios, textos de énfasis en verde, valor hora selected |
| `colorSuccess` | `#2D8653` | Ícono check en pantalla de éxito |
| `colorSuccessCircle` | `#E8F5EE` | Fondo del círculo de éxito |
| `colorBackground` | `#FFFFFF` | Fondo general de pantallas |
| `colorSurface` | `#FFFFFF` | Fondo de tarjetas e inputs |
| `colorBorder` | `#E8E8E8` | Bordes de inputs, tarjetas, chips no seleccionados |
| `colorBorderSelected` | `#2D8653` | Borde chip de hora seleccionado |
| `colorTextPrimary` | `#0D0D0D` | Títulos, texto de campos |
| `colorTextSecondary` | `#757575` | Labels de campo, subtítulos, placeholder |
| `colorTextPrice` | `#2D8653` | Precio en tarjeta de servicio |
| `colorTextSelected` | `#2D8653` | Valor dentro del chip de hora seleccionado |
| `colorInfoBg` | `#EAF4F8` | Fondo del banner informativo en éxito |
| `colorInfoIcon` | `#4A9FC5` | Color del ícono ℹ en el banner |
| `colorButtonPrimary` | `#1A3C2E` | Fondo botón "Agendar" / "Ver solicitud" |
| `colorButtonSecondary` | `#FFFFFF` | Fondo botón "Volver al inicio" |
| `colorButtonSecondaryBorder` | `#1A3C2E` | Borde botón "Volver al inicio" |
| `colorSparkle` | `#4ECDC4` / `#A8E6CF` | Destellos decorativos en pantalla de éxito |

### 1.2 Tipografía

Fuente base: **Inter** (Google Fonts)

| Token | Size | Weight | Color | Uso |
|---|---|---|---|---|
| `textLogo` | 28 sp | 700 Bold | `colorTextPrimary` | Logo "Hulp" |
| `textH1` | 22 sp | 700 Bold | `colorTextPrimary` | "Agenda tu servicio", "¡Reserva confirmada!" |
| `textSubtitle` | 14 sp | 400 Regular | `colorTextSecondary` | Subtítulos de sección |
| `textServiceName` | 15 sp | 600 SemiBold | `colorAccent` | Nombre del servicio en la tarjeta |
| `textServiceDesc` | 13 sp | 400 Regular | `colorTextSecondary` | Descripción del servicio |
| `textPrice` | 15 sp | 600 SemiBold | `colorTextPrice` | "Desde $149,900" |
| `textFieldLabel` | 12 sp | 500 Medium | `colorTextSecondary` | Labels de cada campo |
| `textFieldValue` | 15 sp | 400 Regular | `colorTextPrimary` | Valor seleccionado en inputs |
| `textFieldPlaceholder` | 15 sp | 400 Regular | `colorTextSecondary` | Hint text de inputs |
| `textChipSelected` | 14 sp | 600 SemiBold | `colorTextSelected` | Hora seleccionada |
| `textChipDefault` | 14 sp | 400 Regular | `colorTextPrimary` | Hora no seleccionada |
| `textButtonPrimary` | 17 sp | 600 SemiBold | `#FFFFFF` | "Agendar", "Ver solicitud" |
| `textButtonSecondary` | 17 sp | 600 SemiBold | `colorButtonPrimary` | "Volver al inicio" |
| `textSummaryLabel` | 13 sp | 400 Regular | `colorTextSecondary` | Etiquetas en resumen |
| `textSummaryValue` | 13 sp | 400 Regular | `colorTextPrimary` | Valores en resumen |
| `textSummaryValueAccent` | 13 sp | 600 SemiBold | `colorAccent` | Número solicitud, hora en resumen |

### 1.3 Radios y espaciado

| Token | Valor | Uso |
|---|---|---|
| `radiusCard` | 12 dp | Tarjeta de servicio |
| `radiusInput` | 10 dp | Inputs, chips de hora |
| `radiusButton` | 14 dp | Botones CTA |
| `radiusSummaryCard` | 12 dp | Tarjeta de resumen en éxito |
| `radiusInfoBanner` | 10 dp | Banner informativo |
| `paddingScreenH` | 20 dp | Padding horizontal de pantalla |
| `paddingScreenTop` | 16 dp | Padding superior del body |
| `spacingFieldGap` | 20 dp | Espacio entre campos |
| `spacingLabelGap` | 6 dp | Espacio entre label y su input |
| `paddingInputH` | 14 dp | Padding horizontal interno de inputs |
| `paddingInputV` | 14 dp | Padding vertical interno de inputs |

---

## 2. Componentes reutilizables

### 2.1 `ServiceHeaderCard`
Tarjeta de información del servicio. Aparece en ambas pantallas.

```
┌────────────────────────────────────────────┐
│ [Imagen 80×80 r:8]  Limpieza - Oficina     │  ← textServiceName (green)
│                     Limpieza general de     │  ← textServiceDesc (2 líneas max)
│                     oficina durante…        │
│                     Desde $149,900          │  ← textPrice (green, bold)
└────────────────────────────────────────────┘
```

- **Fondo:** `colorSurface`
- **Borde:** 1 dp `colorBorder`, radius `radiusCard`
- **Sombra:** `BoxShadow(blurRadius: 6, color: rgba(0,0,0,0.06), offset: (0,2))`
- **Imagen:** ClipRRect radius 8, BoxFit.cover, fixed 80×80 dp
- **Padding interno:** 12 dp all sides
- **Gap imagen→texto:** 12 dp horizontal

### 2.2 `FormFieldWrapper`
Contenedor estándar para cada campo del formulario.

```
Label text (12 sp, colorTextSecondary)
6 dp gap
┌──────────────────────────────────────────┐
│ [Icon 20dp]  Valor o placeholder          │ [trailing widget]
└──────────────────────────────────────────┘
error text (12sp, colorError) — solo si hay error
```

- **Borde normal:** 1 dp `colorBorder`, radius `radiusInput`
- **Borde error:** 1.5 dp `colorError` (#D32F2F), radius `radiusInput`
- **Borde focused:** 1.5 dp `colorPrimary`
- **Fondo:** `#F7F8F9`
- **Ícono leading:** 20 dp, color `colorTextSecondary`

### 2.3 `TimeChip`
Chip individual del selector de hora.

**Estado default:**
- Fondo: `#FFFFFF`, borde 1 dp `colorBorder`, radius `radiusInput`
- Texto: `textChipDefault`
- Tamaño: height 42 dp, padding H 16 dp

**Estado selected:**
- Fondo: `colorPrimaryLight` (`#E8F5EE`), borde 1.5 dp `colorBorderSelected`
- Texto: `textChipSelected` (green, semibold)

**Chip "Más":**
- Mismo estilo default + ícono chevron-down a la derecha
- Abre picker de hora nativo al tap

### 2.4 `SummaryRow` (BookingSuccessPage)
Fila de una sola línea dentro del card de resumen.

```
[Icon 18dp, colorAccent]  Label (gray)           Valor (right-aligned)
```

- Ícono: 18 dp, color `colorAccent`
- Label: `textSummaryLabel`, flex: 1
- Valor: `textSummaryValue` (o `textSummaryValueAccent` cuando aplique), align right

---

## 3. Pantalla 1 — `ServiceBookingFormPage`

### 3.1 Layout general

```
Scaffold(backgroundColor: colorBackground)
  AppBar — transparente, sin sombra
    leading: BackButton (colorTextPrimary)
    title: "Hulp" (textLogo)
  body: SingleChildScrollView
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16)
    Column
      ServiceHeaderCard               ← §2.1
      SizedBox(height: 24)
      SectionHeader                   ← "Agenda tu servicio"
      SizedBox(height: 4)
      SectionSubtitle                 ← "Cuéntanos cuándo y dónde..."
      SizedBox(height: 20)
      [Campo Fecha]                   ← §3.2
      SizedBox(height: 20)
      [Campo Hora]                    ← §3.3
      SizedBox(height: 20)
      [Campo Ciudad]                  ← §3.4
      SizedBox(height: 20)
      [Campo Dirección]               ← §3.5
      SizedBox(height: 20)
      [Campo Complemento]             ← §3.6
      SizedBox(height: 32)
      [Botón Agendar]                 ← §3.7
      SizedBox(height: 16)
  BottomNavigationBar               ← §3.8
```

### 3.2 Campo Fecha

```
Label: "Fecha"
┌──────────────────────────────────────────────────────┐
│ [🗓 icon]  Martes, 27 de mayo de 2025          [🗓 >] │
└──────────────────────────────────────────────────────┘
```

- **Ícono leading:** `Icons.event_outlined` o similar (calendar con check), 20 dp
- **Texto de valor:** Formato largo: `EEEE, d 'de' MMMM 'de' yyyy` en español
  - Ejemplo: "Martes, 27 de mayo de 2025"
- **Ícono trailing:** icono de calendario pequeño + chevron `>` (color `colorAccent`), 18 dp
- **Interacción:** todo el campo es tappable → abre `showDatePicker` nativo
- **Restricción:** `firstDate: DateTime.now()` (no fechas pasadas)
- **Estado vacío:** placeholder "Selecciona una fecha" en `colorTextSecondary`
- **Estado error:** borde rojo, texto error debajo: "La fecha es obligatoria"

### 3.3 Campo Hora

```
Label: "Hora"
┌─────────────────────────────────────────────────────────────────┐
│ [🕐 icon]  [08:00✓]  [09:00]  [10:00]  [11:00]  [Más ˅]        │
└─────────────────────────────────────────────────────────────────┘
```

- **Ícono leading:** `Icons.access_time_outlined`, 20 dp, `colorTextSecondary`
- **Chips:** `SingleChildScrollView(scrollDirection: Axis.horizontal)` con chips
- **Chips predefinidos:** `['08:00', '09:00', '10:00', '11:00']` + chip "Más"
- **Chip "Más":** abre `showTimePicker` nativo (permite seleccionar cualquier hora)
- **Selección:** un solo chip activo a la vez; al seleccionar otro se deselecciona el anterior
- **Gap entre chips:** 8 dp
- **Estado error:** borde del contenedor rojo + "La hora es obligatoria" debajo
- **Nota:** el valor almacenado es `TimeOfDay`; chips muestran HH:MM en 24 h

### 3.4 Campo Ciudad

```
Label: "Ciudad"
┌──────────────────────────────────────────────────────┐
│ [🏢 icon]  Bogotá, D.C.                        [  ˅] │
└──────────────────────────────────────────────────────┘
```

- **Ícono leading:** `Icons.location_city_outlined`, 20 dp
- **Tipo:** `DropdownButton<CiudadRow>` dentro de `FutureBuilder<List<CiudadRow>>`
- **Ícono trailing:** chevron-down `Icons.keyboard_arrow_down`, color `colorTextSecondary`
- **Fuente de datos:** tabla `ciudad` en Supabase — query en `initState` filtrando `activo = true`, ordenado por `nombre ASC`. Ver `docs/migrations/0001_geo_tables.sql`.
- **Estado de carga:** mientras el Future no resuelve, muestra spinner `CircularProgressIndicator` (stroke 2, color accent) dentro del contenedor del campo.
- **Valor almacenado:** `CiudadRow` — se persiste `ciudad.id` (UUID) como `ciudad_id` en `solicitudes_servicio` y `ciudad.nombre` como texto legible en `BookingSuccessPage`.
- **Estado error:** borde rojo + "La ciudad es obligatoria"

### 3.5 Campo Dirección

```
Label: "Dirección / referencia de ubicación (opcional)"
┌──────────────────────────────────────────────────────┐
│ [📍 icon]  Calle 85 # 15-32, Oficina 502        [✕] │
└──────────────────────────────────────────────────────┘
```

- **Ícono leading:** `Icons.location_on_outlined`, 20 dp
- **Campo de texto libre**, `keyboardType: TextInputType.streetAddress`
- **Ícono trailing:** `Icons.close` (X), visible solo cuando el campo tiene texto
  - Tap en X → limpia el campo (`controller.clear()`)
  - Color: `colorTextSecondary`, 18 dp
- **Obligatoriedad:** **opcional** — no bloquea el submit

### 3.6 Campo Complemento / Referencia

```
Label: "Complemento / referencia (opcional)"
┌──────────────────────────────────────────────────────┐
│ [📋 icon]  Edificio Centro 85, torre B. Recep...     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

- **Ícono leading:** `Icons.edit_note_outlined` o `Icons.notes`, 20 dp
- **Campo de texto libre**, `maxLines: 2`, `minLines: 2`
- **Placeholder:** "Edificio Centro 85, torre B. Recepción 24/7."
- **Sin trailing widget**
- **Obligatoriedad:** **opcional** (tag explícito en el label)
- **Altura aprox.:** 72 dp (2 líneas)

### 3.7 Botón "Agendar"

```
┌──────────────────────────────────────────────────────┐
│                     Agendar                          │
└──────────────────────────────────────────────────────┘
```

- **Width:** `double.infinity` (full width con padding de pantalla)
- **Height:** 56 dp
- **Background:** `colorButtonPrimary` (`#1A3C2E`)
- **Texto:** "Agendar", `textButtonPrimary` (blanco, 17 sp, semibold)
- **Radius:** `radiusButton` (14 dp)
- **Estado disabled (isSubmitting):** mismo fondo con opacidad 0.6, muestra `CircularProgressIndicator` blanco en lugar del texto
- **Margin bottom:** 24 dp desde el último campo

### 3.8 BottomNavigationBar

```
[🏠 Inicio]   [🕐 Solicitudes]   [👤 Cuenta]
```

- **Background:** `colorBackground` con sombra superior `BoxShadow(blurRadius:12, color: rgba(0,0,0,0.08), offset:(0,-2))`
- **Ítems:** 3 ítems con ícono + label
- **Ítem activo:** color `colorPrimary`
- **Ítem inactivo:** color `colorTextSecondary`
- **Altura total incluyendo safe area:** ~72 dp + safe area bottom

---

## 4. Pantalla 2 — `BookingSuccessPage`

### 4.1 Layout general

```
Scaffold(backgroundColor: colorBackground)
  AppBar — transparente, sin sombra
    leading: (sin back button — SPEC §7.1.3)
    title: "Hulp" (textLogo)
  body: SingleChildScrollView
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16)
    Column
      ServiceHeaderCard (compact)      ← §4.2
      SizedBox(height: 28)
      SuccessIndicator                 ← §4.3
      SizedBox(height: 20)
      SummaryCard                      ← §4.4
      SizedBox(height: 16)
      InfoBanner                       ← §4.5
      SizedBox(height: 32)
      ButtonVerSolicitud               ← §4.6
      SizedBox(height: 12)
      ButtonVolverInicio               ← §4.6
      SizedBox(height: 16)
  BottomNavigationBar                  ← §3.8
```

### 4.2 `ServiceHeaderCard` versión compact (éxito)

Igual que §2.1 pero **sin el precio** visible de forma tan prominente — en el mockup se muestra igual que el form, con el precio. Se mantiene idéntico al de la pantalla del formulario.

### 4.3 Indicador de éxito

```
     ·  ·
  ·         ·
·   [  ✓  ]   ·       ← círculo verde con check blanco
  ·         ·
     ·  ·

    ¡Reserva confirmada!            ← textH1 (bold, colorTextPrimary)

Tu servicio fue agendado con éxito.  ← textSubtitle (gray)
Hemos enviado la información a      ← textSubtitle (gray)
tu sección de solicitudes.
```

- **Círculo:** 80×80 dp, fondo `colorSuccessCircle` (`#E8F5EE`), forma circular
- **Ícono check:** `Icons.check_circle_outline_rounded` (o `Icons.check` dentro de Container), 48 dp, color `colorSuccess` (`#2D8653`)
- **Destellos (sparkles):** 6–8 puntos pequeños (4–6 dp) distribuidos alrededor del círculo en colores `colorSparkle` (`#4ECDC4`, `#A8E6CF`). Pueden implementarse como `CustomPaint` o simplemente como `Container` circulares con `Positioned` dentro de un `Stack`.
- **Gap círculo → título:** 20 dp
- **Gap título → subtítulo:** 8 dp
- **Subtítulo:** 2 líneas, centered

### 4.4 `SummaryCard` — Resumen de tu reserva

```
┌────────────────────────────────────────────────────┐
│ Resumen de tu reserva                              │ ← bold, 15sp
├────────────────────────────────────────────────────┤
│ [📄] Número de solicitud:           #1048          │ ← value en colorAccent
│ [📅] Fecha:        Martes, 27 de mayo de 2025      │
│ [🕐] Hora:                          08:00          │ ← value en colorAccent
│ [🏢] Ciudad:                    Bogotá, D.C.       │
│ [📍] Dirección:     Calle 85 # 15-32, Oficina 502  │
│ [📋] Complemento /   Edificio Centro 85, torre B.  │
│      referencia:     Recepción 24/7.               │
└────────────────────────────────────────────────────┘
```

- **Fondo:** `colorSurface` (`#FFFFFF`)
- **Borde:** 1 dp `colorBorder`, radius `radiusSummaryCard` (12 dp)
- **Sombra:** igual que `ServiceHeaderCard`
- **Padding interno:** 16 dp
- **Título del card:** 15 sp, weight 600, `colorTextPrimary`
- **Divider** entre título y filas: 1 dp `colorBorder`, margin V 12 dp
- **Cada fila:** `SummaryRow` (§2.4), altura mínima 36 dp, padding V 6 dp
- **Ícono por campo:**

| Campo | Ícono sugerido |
|---|---|
| Número de solicitud | `Icons.description_outlined` |
| Fecha | `Icons.calendar_today_outlined` |
| Hora | `Icons.access_time_outlined` |
| Ciudad | `Icons.location_city_outlined` |
| Dirección | `Icons.location_on_outlined` |
| Complemento | `Icons.edit_note_outlined` |

- **Valores especiales en verde** (`colorAccent`, semibold): Número de solicitud, Hora
- **Dirección/Complemento:** puede ser multiline si el texto es largo

### 4.5 `InfoBanner`

```
┌──────────────────────────────────────────────────────┐
│  [ℹ]  Te notificaremos cuando el proveedor           │
│       confirme o sea asignado.                       │
└──────────────────────────────────────────────────────┘
```

- **Fondo:** `colorInfoBg` (`#EAF4F8`)
- **Borde:** ninguno (sin borde)
- **Radius:** `radiusInfoBanner` (10 dp)
- **Padding:** 14 dp H, 12 dp V
- **Ícono:** `Icons.info_outline`, 20 dp, color `colorInfoIcon` (`#4A9FC5`)
- **Texto:** 13 sp, regular, `colorTextSecondary`
- **Gap ícono → texto:** 10 dp

### 4.6 Botones de acción

**Botón primario "Ver solicitud":**
- Mismo estilo que §3.7
- Label: "Ver solicitud"
- Acción: navegar a la pantalla de detalle de la solicitud (ruta por definir en sprint siguiente)

**Botón secundario "Volver al inicio":**
- **Width:** `double.infinity`
- **Height:** 52 dp
- **Background:** `colorButtonSecondary` (`#FFFFFF`)
- **Borde:** 1.5 dp `colorButtonSecondaryBorder` (`#1A3C2E`)
- **Radius:** `radiusButton` (14 dp)
- **Texto:** "Volver al inicio", `textButtonSecondary` (17 sp, semibold, `#1A3C2E`)
- **Acción:** `context.go('/')` — limpia el stack de navegación

---

## 5. Comportamientos e interacciones

### 5.1 Validación en formulario (PA-01, PA-02, PA-03)

| Campo | Requerido | Comportamiento de error                                               |
|---|---|-----------------------------------------------------------------------|
| Fecha | ✅ Sí | Borde rojo en el campo + texto "La fecha es obligatoria" debajo       |
| Hora | ✅ Sí | Borde rojo en el contenedor de chips + texto "La hora es obligatoria" |
| Ciudad | ✅ Sí | Borde rojo + "La ciudad es obligatoria"                               |
| Dirección | ❌ No | Nunca muestra error — campo opcional                                  |
| Complemento | ❌ No | Nunca muestra error                                                   |

- Los errores aparecen **solo al intentar hacer submit** (no onChange).
- Al corregir un campo, su error desaparece inmediatamente (onChange).
- Si hay múltiples errores, todos se muestran simultáneamente.

### 5.2 Estado de carga (isSubmitting)

1. Tap en "Agendar" → validación local pasa
2. Botón: texto desaparece → aparece `CircularProgressIndicator` (blanco, stroke 2.5)
3. Todos los campos quedan deshabilitados (`enabled: false` / `ignorePointer`)
4. Pasado el delay (o respuesta de Supabase): navegar a `BookingSuccessPage`
5. `pushReplacement` — el botón Back no devuelve al formulario

### 5.3 Selector de hora — lógica de chips

- Al cargar la página: ningún chip seleccionado
- Solo un chip puede estar seleccionado a la vez
- Si el usuario selecciona "Más" y elige una hora en el picker nativo, esa hora se muestra como un chip adicional activo (o se muestra en el campo formateado)
- La hora seleccionada en chips se mostrará como "08:00" (formato 24 h, HH:MM)

### 5.4 Campo Dirección — ícono de borrar

- El ícono `✕` es visible **solo cuando `controller.text.isNotEmpty`**
- Al tap: `controller.clear()` + `setState()`
- El campo vuelve al placeholder

---

## 6. Persistencia en Supabase

### 6.1 Tabla destino: `solicitudes_servicio`

Al confirmar el formulario (`_onAgendar`), se hace un insert a `solicitudes_servicio` con el siguiente mapeo:

| Columna en Supabase | Origen | Tipo | Notas |
|---|---|---|---|
| `usuario_id` | `currentUserUid()` | `String` | Usuario autenticado |
| `servicio_id` | `_servicio.id` | `String?` | FK a tabla `servicios` |
| `servicio_nombre` | `_servicio.nombre` | `String?` | Desnormalizado para historial |
| `descripcion` | `_servicio.descripcion` | `String?` | Descripción del servicio contratado |
| `precio` | `_servicio.precio` | `double` | Precio base del servicio |
| `fecha` | `_selectedDate` | `DateTime` | Fecha seleccionada en el formulario |
| `hora` | `_selectedTimeChip` | `PostgresTime` | Hora seleccionada (HH:MM) |
| `ciudad_id` | `_selectedCiudad.id` | `uuid` | FK a tabla `ciudad` — resuelve IP-04 |
| `ubicacion` | `ciudad.nombre + '\n' + direccion + '\n' + complemento` | `String` | Concatenación legible para historial |
| `estado` | `'pendiente'` | `String` | Estado inicial fijo |

### 6.2 Campos que NO se llenan en el insert inicial

Los siguientes campos de la tabla se dejan vacíos (`null`) en el momento del agendamiento y son gestionados por flujos posteriores:

- `profesional_id` — se asigna cuando un profesional acepta
- `estado_pago` — lo gestiona el flujo de pagos
- `ticket` — número de ticket, lo asigna el backend
- `precio_base`, `precio_adicionales` — desglose de precio, sprint posterior
- `fecha_cancelacion`, `fecha_reagendamiento`, `fecha_pago`, `fecha_aceptacion` — eventos futuros
- `solicitud_original_id`, `tipo` — para solicitudes derivadas

### 6.3 Retorno del insert

El insert retorna la fila creada. El `id` y `ticket` (si el backend los genera automáticamente) se usan para armar el `solicitudId` que se muestra en `BookingSuccessPage`.

```dart
// Prioridad para mostrar el número de solicitud:
// 1. ticket (int, más corto y legible)  →  '#${row.ticket}'
// 2. id UUID (fallback)                 →  '#${row.id.substring(0, 6).toUpperCase()}'
```

### 6.4 Ciudades — ✅ Resuelto (v1.3)

Se creó una jerarquía geográfica de 3 tablas en Supabase: `pais → provincia → ciudad`.

**Migración:** `docs/migrations/0001_geo_tables.sql`

**Tablas creadas:**
- `pais` — países (seed: Colombia)
- `provincia` — departamentos (seed: 10 departamentos de Colombia)
- `ciudad` — ciudades (seed: 15 ciudades principales)

**FK agregado:** `solicitudes_servicio.ciudad_id uuid REFERENCES ciudad(id) ON DELETE SET NULL`

**Dart:** `lib/backend/supabase/database/tables/{pais,provincia,ciudad}.dart`

**En `ServiceBookingFormPage`:** `_kCiudades` eliminado. `_ciudadesFuture` carga desde `CiudadTable().queryRows(activo = true, order by nombre)` en `initState`. El dropdown usa `DropdownButton<CiudadRow>`.

---

## 7. Cambios al SPEC funcional originados en el diseño

Los siguientes puntos del diseño resuelven bloqueantes del SPEC funcional original o introducen diferencias:

| # | Bloqueante | Decisión del diseño | Impacto en código |
|---|---|---|---|
| IP-01 | Origen de `service_description` | El diseño muestra una **tarjeta completa** con imagen, nombre, descripción y precio del servicio. Viene de la pantalla anterior (navegación desde detalle del servicio). Se pasa como parámetro a `ServiceBookingFormPage`. | `ServiceBookingFormPage` recibe `ServiciosRow` como parámetro de navegación |
| IP-04 | Ciudad: texto libre vs lista | El diseño muestra **dropdown selector** (`˅`). Es lista predefinida. | Cambiar `TextField` ciudad por `DropdownButtonFormField` |
| IP-02 | Formato de fecha | Formato largo en español: `EEEE, d 'de' MMMM 'de' yyyy`. Selector de calendario nativo. | Usar `intl` package: `DateFormat('EEEE, d \'de\' MMMM \'de\' yyyy', 'es')` |
| IP-03 | Formato de hora | Chips con horas predefinidas (08:00–11:00) + "Más" para picker libre. Formato 24 h. | Añadir chips `TimeChip` + `showTimePicker` en "Más" |
| IP-05 | Diseño de `BookingSuccessPage` | ✅ **Resuelto**: mockup entregado y documentado en §4. | Implementar según §4 de este documento |
| — | Dirección opcional | Campo "Dirección" es **opcional** — no bloquea el submit. Solo son obligatorios: Fecha, Hora y Ciudad. | Eliminar validación de dirección en `_validate()` |
| — | Campos de dirección | El diseño mantiene **dos campos visibles**: "Dirección" + "Complemento / referencia (opcional)". En el backend se concatenan en un único campo antes de persistir. No hay cambio en la UI — los dos campos se conservan tal como están en el mockup. | Concatenar al hacer el insert: `address = direccion + (complemento ?? '')` |
| — | `BookingSuccessPage` con resumen | La pantalla de éxito muestra un **resumen completo** de la reserva + número de solicitud. | `BookingSuccessPage` recibe el objeto completo de la reserva creada |

### 6.1 Parámetros actualizados para `ServiceBookingFormPage`

```dart
class ServiceBookingFormPage extends StatefulWidget {
  const ServiceBookingFormPage({
    super.key,
    required this.servicio,  // ServiciosRow — resuelve IP-01
  });
  final ServiciosRow servicio;
}
```

### 6.2 Parámetros actualizados para `BookingSuccessPage`

```dart
class BookingSuccessPage extends StatelessWidget {
  const BookingSuccessPage({
    super.key,
    required this.solicitudId,   // String — número de solicitud (#1048)
    required this.servicio,      // ServiciosRow — para mostrar la tarjeta
    required this.fecha,         // DateTime
    required this.hora,          // TimeOfDay
    required this.ciudad,        // String
    required this.direccion,     // String
    this.complemento,            // String? — opcional
  });
}
```

### 6.3 Nuevo campo en modelo de datos (Supabase)

Agregar columna `address_complement` a la tabla `services`:

```sql
ALTER TABLE services
  ADD COLUMN IF NOT EXISTS address_complement text; -- nullable, opcional
```

---

*Documento generado a partir del mockup aprobado el 2026-06-10. Próxima revisión: al completar integración con Supabase.*
