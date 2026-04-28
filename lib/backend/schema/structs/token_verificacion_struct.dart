// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TokenVerificacionStruct extends BaseStruct {
  TokenVerificacionStruct({
    String? status,
  }) : _status = status;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  static TokenVerificacionStruct fromMap(Map<String, dynamic> data) =>
      TokenVerificacionStruct(
        status: data['status'] as String?,
      );

  static TokenVerificacionStruct? maybeFromMap(dynamic data) => data is Map
      ? TokenVerificacionStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'status': _status,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
      }.withoutNulls;

  static TokenVerificacionStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      TokenVerificacionStruct(
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TokenVerificacionStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TokenVerificacionStruct && status == other.status;
  }

  @override
  int get hashCode => const ListEquality().hash([status]);
}

TokenVerificacionStruct createTokenVerificacionStruct({
  String? status,
}) =>
    TokenVerificacionStruct(
      status: status,
    );
