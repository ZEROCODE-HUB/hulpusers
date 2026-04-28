import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'recibo2_widget.dart' show Recibo2Widget;
import 'package:flutter/material.dart';

class Recibo2Model extends FlutterFlowModel<Recibo2Widget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Query Rows] action in Container widget.
  List<TarjetasGuardadasRow>? tarjeta;
  // Stores action output result for [Custom Action - getAcceptanceToken] action in Container widget.
  dynamic aceptaceToken;
  // Stores action output result for [Custom Action - createTransaction] action in Container widget.
  dynamic pago;
  // Stores action output result for [Custom Action - getAcceptanceToken] action in Container widget.
  dynamic aceptaceToken1;
  // Stores action output result for [Custom Action - createBancolombiaTransferTransaction] action in Container widget.
  dynamic pago1;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
