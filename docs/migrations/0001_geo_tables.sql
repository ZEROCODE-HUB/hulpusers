-- ============================================================
-- Migration 0001: Tablas geográficas pais / provincia / ciudad
-- + FK ciudad_id en solicitudes_servicio
-- Ejecutar en: Supabase SQL Editor (sandbox y luego producción)
-- ============================================================

-- ── 1. Tabla pais ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS pais (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre     text NOT NULL,
  codigo     text,                        -- ISO 3166-1 alpha-2, ej: 'CO'
  activo     boolean NOT NULL DEFAULT true,
  creado_en  timestamptz NOT NULL DEFAULT now()
);

-- ── 2. Tabla provincia ────────────────────────────────────
CREATE TABLE IF NOT EXISTS provincia (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  pais_id    uuid NOT NULL REFERENCES pais(id) ON DELETE CASCADE,
  nombre     text NOT NULL,
  activo     boolean NOT NULL DEFAULT true,
  creado_en  timestamptz NOT NULL DEFAULT now()
);

-- ── 3. Tabla ciudad ───────────────────────────────────────
CREATE TABLE IF NOT EXISTS ciudad (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  provincia_id uuid NOT NULL REFERENCES provincia(id) ON DELETE CASCADE,
  nombre       text NOT NULL,
  activo       boolean NOT NULL DEFAULT true,
  creado_en    timestamptz NOT NULL DEFAULT now()
);

-- ── 4. FK en solicitudes_servicio ─────────────────────────
ALTER TABLE solicitudes_servicio
  ADD COLUMN IF NOT EXISTS ciudad_id uuid REFERENCES ciudad(id) ON DELETE SET NULL;

-- ── 5. RLS: lectura pública (anon y authenticated) ────────
ALTER TABLE pais      ENABLE ROW LEVEL SECURITY;
ALTER TABLE provincia ENABLE ROW LEVEL SECURITY;
ALTER TABLE ciudad    ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "pais_select"      ON pais;
DROP POLICY IF EXISTS "provincia_select" ON provincia;
DROP POLICY IF EXISTS "ciudad_select"    ON ciudad;

CREATE POLICY "pais_select"
  ON pais FOR SELECT USING (true);

CREATE POLICY "provincia_select"
  ON provincia FOR SELECT USING (true);

CREATE POLICY "ciudad_select"
  ON ciudad FOR SELECT USING (true);

-- ── 6. Seed: Colombia ─────────────────────────────────────
-- Insertar país
WITH ins_pais AS (
  INSERT INTO pais (nombre, codigo)
  VALUES ('Colombia', 'CO')
  ON CONFLICT DO NOTHING
  RETURNING id
),

-- Insertar departamentos (provincias)
ins_provincias AS (
  INSERT INTO provincia (pais_id, nombre)
  SELECT id, unnest(ARRAY[
    'Bogotá D.C.',
    'Antioquia',
    'Valle del Cauca',
    'Atlántico',
    'Bolívar',
    'Santander',
    'Risaralda',
    'Caldas',
    'Cundinamarca',
    'Nariño'
  ])
  FROM ins_pais
  RETURNING id, nombre
)

-- Insertar ciudades por departamento
INSERT INTO ciudad (provincia_id, nombre)
SELECT p.id, c.nombre
FROM ins_provincias p
JOIN (VALUES
  ('Bogotá D.C.',    'Bogotá D.C.'),
  ('Antioquia',      'Medellín'),
  ('Antioquia',      'Bello'),
  ('Antioquia',      'Itagüí'),
  ('Valle del Cauca','Cali'),
  ('Valle del Cauca','Buenaventura'),
  ('Atlántico',      'Barranquilla'),
  ('Atlántico',      'Soledad'),
  ('Bolívar',        'Cartagena'),
  ('Santander',      'Bucaramanga'),
  ('Santander',      'Floridablanca'),
  ('Risaralda',      'Pereira'),
  ('Caldas',         'Manizales'),
  ('Cundinamarca',   'Soacha'),
  ('Nariño',         'Pasto')
) AS c(departamento, nombre) ON p.nombre = c.departamento;

-- ── 7. Índices ────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_provincia_pais_id ON provincia(pais_id);
CREATE INDEX IF NOT EXISTS idx_ciudad_provincia_id ON ciudad(provincia_id);
CREATE INDEX IF NOT EXISTS idx_ciudad_activo ON ciudad(activo);
CREATE INDEX IF NOT EXISTS idx_solicitudes_ciudad_id ON solicitudes_servicio(ciudad_id);
