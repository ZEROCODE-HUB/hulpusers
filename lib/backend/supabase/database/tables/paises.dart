import '../database.dart';

class PaisesTable extends SupabaseTable<PaisesRow> {
  @override
  String get tableName => 'paises';

  @override
  PaisesRow createRow(Map<String, dynamic> data) => PaisesRow(data);
}

class PaisesRow extends SupabaseDataRow {
  PaisesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PaisesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get nombre => getField<String>('nombre') ?? '';
  set nombre(String value) => setField<String>('nombre', value);

  String? get codigo => getField<String>('codigo');
  set codigo(String? value) => setField<String>('codigo', value);

  bool get activo => getField<bool>('activo') ?? true;
  set activo(bool value) => setField<bool>('activo', value);

  DateTime? get creadoEn => getField<DateTime>('creado_en');
  set creadoEn(DateTime? value) => setField<DateTime>('creado_en', value);
}
