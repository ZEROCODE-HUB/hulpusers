import '../database.dart';

class CiudadTable extends SupabaseTable<CiudadRow> {
  @override
  String get tableName => 'ciudad';

  @override
  CiudadRow createRow(Map<String, dynamic> data) => CiudadRow(data);
}

class CiudadRow extends SupabaseDataRow {
  CiudadRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CiudadTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get provinciaId => getField<String>('provincia_id') ?? '';
  set provinciaId(String value) => setField<String>('provincia_id', value);

  String get nombre => getField<String>('nombre') ?? '';
  set nombre(String value) => setField<String>('nombre', value);

  bool get activo => getField<bool>('activo') ?? true;
  set activo(bool value) => setField<bool>('activo', value);

  DateTime? get creadoEn => getField<DateTime>('creado_en');
  set creadoEn(DateTime? value) => setField<DateTime>('creado_en', value);
}
