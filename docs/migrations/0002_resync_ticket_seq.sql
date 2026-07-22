-- ============================================================
-- Migration 0002: Resincronizar la secuencia `ticket_seq` de
-- solicitudes_servicio  (corrige "No se pudo agendar el servicio")
-- Ejecutar en: Supabase SQL Editor (o Management API)
-- Aplicado en PRODUCCIÓN: 2026-07-07
--
-- CAUSA RAÍZ (solo producción):
--   `solicitudes_servicio.ticket` tiene DEFAULT nextval('ticket_seq') y un
--   UNIQUE(ticket). El panel admin insertaba `ticket` de forma EXPLÍCITA como
--   MAX(ticket)+1, de modo que la tabla avanzaba pero la secuencia `ticket_seq`
--   NO. La secuencia quedó rezagada (last_value=1458 con MAX(ticket)=1460).
--   Cuando un cliente OMITE `ticket` (la app de usuarios, REQ-001),
--   nextval('ticket_seq') devuelve un valor ya existente → viola el UNIQUE
--   (SQLSTATE 23505) → "No se pudo agendar el servicio. Intenta de nuevo.".
--
--   El entorno de TEST NO requiere esta migración: su secuencia ya estaba
--   sincronizada (last_value=1005 = MAX(ticket)).
--
-- PREVENCIÓN PERMANENTE: el panel admin (crear_solicitud_widget.dart) deja de
--   calcular `ticket` a mano y pasa a usar la secuencia (omite la columna),
--   igual que la app de usuarios. Así ambos clientes avanzan la MISMA secuencia
--   y no vuelve a desincronizarse.
--
-- Idempotente: re-ejecutable sin efectos adversos (solo mueve la secuencia
-- hacia adelante; no toca datos existentes).
-- ============================================================

-- ── 1. Resincronizar la secuencia (fix inmediato) ─────────
-- El próximo nextval() devolverá MAX(ticket)+1, libre de colisiones.
SELECT setval('ticket_seq',
              (SELECT COALESCE(MAX(ticket), 0) FROM solicitudes_servicio));

-- ── 2. Salvaguarda permanente contra desincronización ─────
-- Si algún cliente inserta `ticket` de forma EXPLÍCITA (p. ej. una versión
-- antigua del panel admin aún no redesplegada), este trigger avanza
-- `ticket_seq` de inmediato para que un nextval() posterior nunca colisione
-- con el UNIQUE(ticket). Para inserts que omiten `ticket` (el DEFAULT ya
-- corrió y NEW.ticket = último nextval) el setval es un no-op.
CREATE OR REPLACE FUNCTION sync_ticket_seq() RETURNS trigger AS $$
BEGIN
  IF NEW.ticket IS NOT NULL THEN
    PERFORM setval('ticket_seq',
                   GREATEST(NEW.ticket, (SELECT last_value FROM ticket_seq)));
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sync_ticket_seq ON solicitudes_servicio;
CREATE TRIGGER trg_sync_ticket_seq
  BEFORE INSERT ON solicitudes_servicio
  FOR EACH ROW EXECUTE FUNCTION sync_ticket_seq();

-- ── Verificación (opcional, solo lectura) ─────────────────
-- select last_value from ticket_seq;                 -- debe ser = MAX(ticket)
-- select max(ticket) from solicitudes_servicio;
