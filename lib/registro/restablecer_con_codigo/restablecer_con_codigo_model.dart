import '/flutter_flow/flutter_flow_model.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'restablecer_con_codigo_widget.dart' show RestablecerConCodigoWidget;
import 'package:flutter/material.dart';

class RestablecerConCodigoModel
    extends FlutterFlowModel<RestablecerConCodigoWidget> {
  FocusNode? codeFocusNode;
  TextEditingController? codeTextController;

  FocusNode? newPasswordFocusNode;
  TextEditingController? newPasswordTextController;
  late bool newPasswordVisibility = false;

  FocusNode? confirmPasswordFocusNode;
  TextEditingController? confirmPasswordTextController;
  late bool confirmPasswordVisibility = false;

  bool isLoading = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    codeFocusNode?.dispose();
    codeTextController?.dispose();
    newPasswordFocusNode?.dispose();
    newPasswordTextController?.dispose();
    confirmPasswordFocusNode?.dispose();
    confirmPasswordTextController?.dispose();
  }
}
