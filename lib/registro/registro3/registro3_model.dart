import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'registro3_widget.dart' show Registro3Widget;
import 'package:flutter/material.dart';

class Registro3Model extends FlutterFlowModel<Registro3Widget> {
  ///  Local state fields for this page.

  int? otp;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (FinalSendgridCall)] action in Registro3 widget.
  ApiCallResponse? apiResultn36;
  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
  }

  @override
  void dispose() {
    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();
  }
}
