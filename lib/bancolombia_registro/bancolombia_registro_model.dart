import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'bancolombia_registro_widget.dart' show BancolombiaRegistroWidget;
import 'package:flutter/material.dart';

class BancolombiaRegistroModel
    extends FlutterFlowModel<BancolombiaRegistroWidget> {
  ///  Local state fields for this page.

  String? idtoken;

  bool registro = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in BancolombiaRegistro widget.
  List<MetodosPagoRow>? bancolombiaActual;
  // Stores action output result for [Custom Action - getAcceptanceToken] action in BancolombiaRegistro widget.
  dynamic aceptaceToken2;
  // Stores action output result for [Backend Call - API (Bancolombia Sandobox)] action in Button widget.
  ApiCallResponse? apiResultsmp;
  // Stores action output result for [Backend Call - API (Bancolombia verificacion ID)] action in Button widget.
  ApiCallResponse? verificacionToken;
  // Stores action output result for [Backend Call - API (Bancolombia paymentsources)] action in Button widget.
  ApiCallResponse? apiPaymentSource;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  MetodosPagoRow? subida;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<MetodosPagoRow>? useridexist;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
