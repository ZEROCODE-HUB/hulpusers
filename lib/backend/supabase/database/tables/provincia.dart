import '../database.dart';

class ProvinciaTable extends SupabaseTable<ProvinciaRow> {
  @override
  String get tableName => 'provincia';

  @override
  ProvinciaRow createRow(Map<String, dynamic> data) => ProvinciaRow(data);
}

class ProvinciaRow extends SupabaseDataRow {
  ProvinciaRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProvinciaTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get paisId => getField<String>('pais_id') ?? '';
  set paisId(String value) => setField<String>('pais_id', value);

  String get nombre => getField<String>('nombre') ?? '';
  set nombre(String value) => setField<String>('nombre', value);

  bool get activo => getField<bool>('activo') ?? true;
  set activo(bool value) => setField<bool>('activo', value);

  DateTime? get creadoEn => getField<DateTime>('creado_en');
  set creadoEn(DateTime? value) => setField<DateTime>('creado_en', value);
}
