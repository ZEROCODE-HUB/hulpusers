import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _Mensajes = prefs
              .getStringList('ff_Mensajes')
              ?.map((x) {
                try {
                  return DTMensajesIAStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _Mensajes;
    });
    _safeInit(() {
      _notificacionId = prefs.getString('ff_notificacionId') ?? _notificacionId;
    });
    _safeInit(() {
      _metodoPagoPreferencia =
          prefs.getString('ff_metodoPagoPreferencia') ?? _metodoPagoPreferencia;
    });
    _safeInit(() {
      _idToken = prefs.getString('ff_idToken') ?? _idToken;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<DTMensajesIAStruct> _Mensajes = [];
  List<DTMensajesIAStruct> get Mensajes => _Mensajes;
  set Mensajes(List<DTMensajesIAStruct> value) {
    _Mensajes = value;
    prefs.setStringList(
        'ff_Mensajes', value.map((x) => x.serialize()).toList());
  }

  void addToMensajes(DTMensajesIAStruct value) {
    Mensajes.add(value);
    prefs.setStringList(
        'ff_Mensajes', _Mensajes.map((x) => x.serialize()).toList());
  }

  void removeFromMensajes(DTMensajesIAStruct value) {
    Mensajes.remove(value);
    prefs.setStringList(
        'ff_Mensajes', _Mensajes.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromMensajes(int index) {
    Mensajes.removeAt(index);
    prefs.setStringList(
        'ff_Mensajes', _Mensajes.map((x) => x.serialize()).toList());
  }

  void updateMensajesAtIndex(
    int index,
    DTMensajesIAStruct Function(DTMensajesIAStruct) updateFn,
  ) {
    Mensajes[index] = updateFn(_Mensajes[index]);
    prefs.setStringList(
        'ff_Mensajes', _Mensajes.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInMensajes(int index, DTMensajesIAStruct value) {
    Mensajes.insert(index, value);
    prefs.setStringList(
        'ff_Mensajes', _Mensajes.map((x) => x.serialize()).toList());
  }

  String _notificacionId = '';
  String get notificacionId => _notificacionId;
  set notificacionId(String value) {
    _notificacionId = value;
    prefs.setString('ff_notificacionId', value);
  }

  String _metodoPagoPreferencia = '';
  String get metodoPagoPreferencia => _metodoPagoPreferencia;
  set metodoPagoPreferencia(String value) {
    _metodoPagoPreferencia = value;
    prefs.setString('ff_metodoPagoPreferencia', value);
  }

  String _idToken = '';
  String get idToken => _idToken;
  set idToken(String value) {
    _idToken = value;
    prefs.setString('ff_idToken', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
