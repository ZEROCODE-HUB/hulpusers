import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'resenas_widget.dart' show ResenasWidget;
import 'package:flutter/material.dart';

class ResenasModel extends FlutterFlowModel<ResenasWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for RatingBar widget.
  double? ratingBarValue;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<SolicitudesServicioRow>? solicitud;
  // Stores action output result for [Backend Call - Insert Row] action in Button widget.
  ResenasRow? comentarioResponse;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
