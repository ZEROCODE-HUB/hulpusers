# SPEC — REQ-003: Recuperar y Cambiar contraseña (OTP de 6 dígitos)

> Sprint: S 07-2026 · Versión: 1.0 · Estado: **IMPLEMENTADO**
>
> **Changelog:**
> - v1.0 (2026-07-01): Creación. Migra el flujo de "Recuperar contraseña" de enlace mágico (`resetPasswordForEmail` + deep link `redirectTo`) a **código OTP de 6 dígitos** (`verifyOTP` con `OtpType.recovery`). Añade la pantalla de "Cambiar contraseña" en el perfil (`/miperfil`), inexistente hasta ahora.

---

## 1. Contexto

El cliente necesita poder (a) recuperar su contraseña cuando la olvidó (deslogueado) y (b) cambiarla estando autenticado, desde el perfil. Antes existían pantallas de recuperación basadas en enlace por email (`resetPasswordForEmail` con `redirectTo` a `hulp://hulp.com/restablecercontrasea`), que dependían de deep links no cableados en `main.dart`. Se reemplaza por un flujo de **código OTP de 6 dígitos** que no requiere deep links.

La misma base Supabase de producción (`zexegravzidwloxeimxx`) es usada por `hulp-usuarios` y `talento-hulp`; la plantilla de email de "Reset Password" fue configurada (vía Management API) para mostrar `{{ .Token }}` (código de 6 dígitos) conservando `{{ .ConfirmationURL }}` como fallback.

## 2. Flujo de Recuperar contraseña (deslogueado)

1. **Login** → link "¿Olvidaste tu contraseña?" → `RecuperarcontraseaWidget` (`/recuperarcontrasea`). Sin cambios en el link.
2. **`RecuperarcontraseaWidget`** (`lib/registro/recuperarcontrasea/recuperarcontrasea_widget.dart`): valida que el correo exista con `actions.checkEmail(...)`. Si existe, llama `SupaFlow.client.auth.resetPasswordForEmail(email)` (sin `redirectTo`) y navega a `RestablecerConCodigoWidget` pasando `correo` como query param. Si no existe, muestra diálogo "El correo electronico no existe".
3. **`RestablecerConCodigoWidget`** (`lib/registro/restablecer_con_codigo/`): pantalla única con **código (6 dígitos)** + **nueva contraseña** + **confirmar**. Al enviar:
   - `SupaFlow.client.auth.verifyOTP(email: correo, token: código, type: OtpType.recovery)`. Si `session == null` → error "Código inválido o expirado".
   - `SupaFlow.client.auth.updateUser(UserAttributes(password: nueva))`.
   - `prepareAuthEvent()` → `signOut()` → `clearRedirectLocation()` → `pushNamedAuth(Restablecercontrasea2Widget.routeName)` (pantalla de éxito existente).
   - Link "Reenviar" → `resetPasswordForEmail(correo)` de nuevo.
4. **`Restablecercontrasea2Widget`** (`/restablecercontrasea2`): pantalla de éxito existente, sin cambios.

Las pantallas antiguas `RestablecercontraseaWidget` (`/restablecercontrasea`) y `Restablecercontrasea3Widget` (`/restablecercontrasea3`) quedan **huérfanas** (sin uso) tras la migración; no se eliminan.

### 2.1 Validaciones
- Código: exactamente 6 dígitos numéricos (`^\d{6}$`).
- Contraseña: mínimo 8 caracteres, ≥1 mayúscula, ≥1 número; confirmación debe coincidir.

## 3. Flujo de Cambiar contraseña (autenticado)

1. **Perfil** `MiperfilWidget` (`/miperfil`, `lib/registro/pages/miperfil/miperfil_widget.dart`): nueva opción "Cambiar contraseña" (icono candado) insertada antes de "Desactivar cuenta", navega a `CambiarContrasenaWidget`.
2. **`CambiarContrasenaWidget`** (`lib/cambiar_contrasena/`): campos **contraseña actual** + **nueva** + **confirmar**. Al enviar:
   - Reautentica con `SupaFlow.client.auth.signInWithPassword(email: currentUserEmail, password: actual)`. Si falla/`user == null` → "La contraseña actual es incorrecta".
   - `SupaFlow.client.auth.updateUser(UserAttributes(password: nueva))` → éxito → `context.pop()`.
   - Mismas validaciones de contraseña que §2.1, más "la nueva debe ser distinta de la actual".

Replica el patrón hecho a mano de `talento-hulp/lib/pages/cambiar_contrasena/`.

## 4. Rutas y registro

- Nuevas rutas en `lib/flutter_flow/nav/nav.dart`: `RestablecerConCodigoWidget` (con param `correo`) y `CambiarContrasenaWidget`.
- Nuevos `export` en `lib/index.dart`.

## 5. Alcance

Solo se modifica el flujo de contraseña. No cambia login, registro, ni otra lógica. Los tipos `OtpType`, `UserAttributes`, `AuthException` se importan explícitamente de `package:supabase_flutter/supabase_flutter.dart` (el barrel `/backend/supabase/supabase.dart` no los re-exporta).

## 6. Dependencia de configuración (Supabase)

La plantilla de email "Reset Password" en producción debe contener `{{ .Token }}` para que el usuario reciba el código. `mailer_otp_length = 6`, `mailer_otp_exp = 3600` (1 h). ⚠️ Con SMTP por defecto de Supabase el `rate_limit_email_sent = 2`/hora limita las pruebas.
