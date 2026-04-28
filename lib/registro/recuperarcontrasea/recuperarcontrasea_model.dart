import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'recuperarcontrasea_widget.dart' show RecuperarcontraseaWidget;
import 'package:flutter/material.dart';

class RecuperarcontraseaModel
    extends FlutterFlowModel<RecuperarcontraseaWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextFieldEmail widget.
  FocusNode? textFieldEmailFocusNode;
  TextEditingController? textFieldEmailTextController;
  String? Function(BuildContext, String?)?
      textFieldEmailTextControllerValidator;
  String? _textFieldEmailTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Correo electrónico es obligatorio';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Debe ser un correo valido';
    }
    return null;
  }

  // Stores action output result for [Custom Action - checkEmail] action in Button widget.
  bool? emailExist;

  @override
  void initState(BuildContext context) {
    textFieldEmailTextControllerValidator =
        _textFieldEmailTextControllerValidator;
  }

  @override
  void dispose() {
    textFieldEmailFocusNode?.dispose();
    textFieldEmailTextController?.dispose();
  }
}
