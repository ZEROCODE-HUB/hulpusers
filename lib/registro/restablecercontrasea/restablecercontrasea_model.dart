import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'restablecercontrasea_widget.dart' show RestablecercontraseaWidget;
import 'package:flutter/material.dart';

class RestablecercontraseaModel
    extends FlutterFlowModel<RestablecercontraseaWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextFieldPassword widget.
  FocusNode? textFieldPasswordFocusNode;
  TextEditingController? textFieldPasswordTextController;
  late bool textFieldPasswordVisibility;
  String? Function(BuildContext, String?)?
      textFieldPasswordTextControllerValidator;
  String? _textFieldPasswordTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'La contraseña es obligatoria';
    }

    return null;
  }

  // State field(s) for TextFieldPassword2 widget.
  FocusNode? textFieldPassword2FocusNode;
  TextEditingController? textFieldPassword2TextController;
  late bool textFieldPassword2Visibility;
  String? Function(BuildContext, String?)?
      textFieldPassword2TextControllerValidator;
  String? _textFieldPassword2TextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Confirme su contraseña';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    textFieldPasswordVisibility = false;
    textFieldPasswordTextControllerValidator =
        _textFieldPasswordTextControllerValidator;
    textFieldPassword2Visibility = false;
    textFieldPassword2TextControllerValidator =
        _textFieldPassword2TextControllerValidator;
  }

  @override
  void dispose() {
    textFieldPasswordFocusNode?.dispose();
    textFieldPasswordTextController?.dispose();

    textFieldPassword2FocusNode?.dispose();
    textFieldPassword2TextController?.dispose();
  }
}
