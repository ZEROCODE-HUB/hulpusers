// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DTMensajesIAStruct extends BaseStruct {
  DTMensajesIAStruct({
    String? rol,
    String? mensaje,
    String? fecha,
  })  : _rol = rol,
        _mensaje = mensaje,
        _fecha = fecha;

  // "Rol" field.
  String? _rol;
  String get rol => _rol ?? '';
  set rol(String? val) => _rol = val;

  bool hasRol() => _rol != null;

  // "Mensaje" field.
  String? _mensaje;
  String get mensaje => _mensaje ?? '';
  set mensaje(String? val) => _mensaje = val;

  bool hasMensaje() => _mensaje != null;

  // "Fecha" field.
  String? _fecha;
  String get fecha => _fecha ?? '';
  set fecha(String? val) => _fecha = val;

  bool hasFecha() => _fecha != null;

  static DTMensajesIAStruct fromMap(Map<String, dynamic> data) =>
      DTMensajesIAStruct(
        rol: data['Rol'] as String?,
        mensaje: data['Mensaje'] as String?,
        fecha: data['Fecha'] as String?,
      );

  static DTMensajesIAStruct? maybeFromMap(dynamic data) => data is Map
      ? DTMensajesIAStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'Rol': _rol,
        'Mensaje': _mensaje,
        'Fecha': _fecha,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Rol': serializeParam(
          _rol,
          ParamType.String,
        ),
        'Mensaje': serializeParam(
          _mensaje,
          ParamType.String,
        ),
        'Fecha': serializeParam(
          _fecha,
          ParamType.String,
        ),
      }.withoutNulls;

  static DTMensajesIAStruct fromSerializableMap(Map<String, dynamic> data) =>
      DTMensajesIAStruct(
        rol: deserializeParam(
          data['Rol'],
          ParamType.String,
          false,
        ),
        mensaje: deserializeParam(
          data['Mensaje'],
          ParamType.String,
          false,
        ),
        fecha: deserializeParam(
          data['Fecha'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DTMensajesIAStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DTMensajesIAStruct &&
        rol == other.rol &&
        mensaje == other.mensaje &&
        fecha == other.fecha;
  }

  @override
  int get hashCode => const ListEquality().hash([rol, mensaje, fecha]);
}

DTMensajesIAStruct createDTMensajesIAStruct({
  String? rol,
  String? mensaje,
  String? fecha,
}) =>
    DTMensajesIAStruct(
      rol: rol,
      mensaje: mensaje,
      fecha: fecha,
    );
