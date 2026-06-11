# Instrucciones del proyecto Hulp — Cliente

## Comportamiento esperado

- Al terminar cualquier tarea, siempre proporcionar un título de commit sugerido siguiendo Conventional Commits, **siempre en inglés**:
  ```
  <type>(<scope>): <short description>
  ```
  Ejemplos: `feat(booking): add insert to solicitudes_servicio`, `fix(env): correct environment selection in debug mode`, `docs(spec): update REQ-001 v1.2 with persistence section`

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
- **Ciudades**: actualmente hardcoded en `_kCiudades`. Pendiente tabla Supabase.
