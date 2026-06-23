# Instrucciones del proyecto Hulp — Cliente

## Enfoque de desarrollo: Spec Driven Development (SDD)

Este proyecto sigue **Spec Driven Development**. El spec es la fuente de verdad. El código implementa lo que el spec dice — nunca al revés.

## Comportamiento esperado

### Antes de tocar cualquier línea de código relacionada con funcionalidad de la app:

1. **Actualizar primero el spec** correspondiente en `docs/specs/`. Refleja el cambio que se va a hacer: nuevas columnas, nueva lógica, cambios de UI, etc.
2. **Indicar explícitamente** que el spec fue actualizado (versión, sección y qué cambió).
3. **Solo entonces** hacer el cambio en el código, basándose en lo que dice el spec actualizado.

> Si no existe un spec para la funcionalidad, crearlo antes de codificar.

### Al terminar cualquier tarea:
- Proporcionar un título de commit sugerido siguiendo Conventional Commits, **siempre en inglés**:
  ```
  <type>(<scope>): <short description>
  ```
  Ejemplos: `feat(booking): add insert to solicitudes_servicio`, `fix(env): correct environment selection in debug mode`, `docs(spec): update REQ-001 v1.3 with ciudad dynamic loading`

## Stack técnico

- Flutter 3.35.0 / Dart 3.9.0 — exportado desde FlutterFlow
- Supabase (local Docker para Test, cloud para Sandbox y Production)
- GoRouter con wrapper FFRoute/FFParameters de FlutterFlow

## Ambientes

| Nombre | Archivo | Selección |
|---|---|---|
| Test | `environment_test.json` | Automático en `kDebugMode` sin flag |
| Sandbox | `environment_sandbox.json` | `--dart-define=ENVIRONMENT=Sandbox` |
| Production | `environment.json` | Release sin flag o `--dart-define=ENVIRONMENT=Production` |

## Patrones establecidos

- **GoRouter + objetos Dart**: usar store singleton (`ServiceStore`, `BookingArgsStore`) en lugar de `extra`. FlutterFlow castea `extra` a `Map<String, dynamic>` incondicionalmente.
- **Specs**: guardar en `docs/specs/SPEC_<REQ-XXX>_<nombre>.md`. Se commitean al repo para historial SDD.
- **Ciudades**: cargadas dinámicamente desde tabla `ciudad` en Supabase. `_kCiudades` eliminado. Ver migración `docs/migrations/0001_geo_tables.sql`.
