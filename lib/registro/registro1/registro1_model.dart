import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'registro1_widget.dart' show Registro1Widget;
import 'package:flutter/material.dart';

class Registro1Model extends FlutterFlowModel<Registro1Widget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for TextFieldnom widget.
  FocusNode? textFieldnomFocusNode;
  TextEditingController? textFieldnomTextController;
  String? Function(BuildContext, String?)? textFieldnomTextControllerValidator;
  String? _textFieldnomTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Nombre * es requerido';
    }

    return null;
  }

  // State field(s) for TextFieldap widget.
  FocusNode? textFieldapFocusNode;
  TextEditingController? textFieldapTextController;
  String? Function(BuildContext, String?)? textFieldapTextControllerValidator;
  String? _textFieldapTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Apellidos * es requerido';
    }

    return null;
  }

  // State field(s) for Documento widget.
  String? documentoValue;
  FormFieldController<String>? documentoValueController;
  // State field(s) for TextFieldnumdoc widget.
  FocusNode? textFieldnumdocFocusNode;
  TextEditingController? textFieldnumdocTextController;
  String? Function(BuildContext, String?)?
      textFieldnumdocTextControllerValidator;
  // State field(s) for Pais widget.
  String? paisValue;
  FormFieldController<String>? paisValueController;
  // State field(s) for TextFieldtel widget.
  FocusNode? textFieldtelFocusNode;
  TextEditingController? textFieldtelTextController;
  String? Function(BuildContext, String?)? textFieldtelTextControllerValidator;
  String? _textFieldtelTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Teléfono * es requerido';
    }

    return null;
  }

  // State field(s) for TextFieldcorr widget.
  FocusNode? textFieldcorrFocusNode;
  TextEditingController? textFieldcorrTextController;
  String? Function(BuildContext, String?)? textFieldcorrTextControllerValidator;
  String? _textFieldcorrTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Correo electrónico * es requerido';
    }

    return null;
  }

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController6;
  String? Function(BuildContext, String?)? textController6Validator;
  bool isDataUploading_imagenperfil = false;
  FFUploadedFile uploadedLocalFile_imagenperfil =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_imagenperfil = '';

  // Stores action output result for [Custom Action - checkEmail] action in Button widget.
  bool? emailExist;

  @override
  void initState(BuildContext context) {
    textFieldnomTextControllerValidator = _textFieldnomTextControllerValidator;
    textFieldapTextControllerValidator = _textFieldapTextControllerValidator;
    textFieldtelTextControllerValidator = _textFieldtelTextControllerValidator;
    textFieldcorrTextControllerValidator =
        _textFieldcorrTextControllerValidator;
  }

  @override
  void dispose() {
    textFieldnomFocusNode?.dispose();
    textFieldnomTextController?.dispose();

    textFieldapFocusNode?.dispose();
    textFieldapTextController?.dispose();

    textFieldnumdocFocusNode?.dispose();
    textFieldnumdocTextController?.dispose();

    textFieldtelFocusNode?.dispose();
    textFieldtelTextController?.dispose();

    textFieldcorrFocusNode?.dispose();
    textFieldcorrTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController6?.dispose();
  }
}
