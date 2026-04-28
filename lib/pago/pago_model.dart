import '/flutter_flow/flutter_flow_util.dart';
import 'pago_widget.dart' show PagoWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PagoModel extends FlutterFlowModel<PagoWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for titular widget.
  FocusNode? titularFocusNode;
  TextEditingController? titularTextController;
  String? Function(BuildContext, String?)? titularTextControllerValidator;
  String? _titularTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'El nombre del titular es obligatorio';
    }

    if (val.length < 6) {
      return 'El nombre del titular debe contener al menos 6 caracteres';
    }

    return null;
  }

  // State field(s) for numeroTarjeta widget.
  FocusNode? numeroTarjetaFocusNode;
  TextEditingController? numeroTarjetaTextController;
  String? Function(BuildContext, String?)? numeroTarjetaTextControllerValidator;
  String? _numeroTarjetaTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'El número de tarjeta es obligatorio';
    }

    if (val.length < 16) {
      return 'Ingrese todos los numeros por favor';
    }

    return null;
  }

  // State field(s) for fechaVenc widget.
  FocusNode? fechaVencFocusNode;
  TextEditingController? fechaVencTextController;
  late MaskTextInputFormatter fechaVencMask;
  String? Function(BuildContext, String?)? fechaVencTextControllerValidator;
  String? _fechaVencTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'La fecha de vencimiento es obligatorio';
    }

    if (val.length < 5) {
      return 'Numeros de fecha no valida';
    }

    return null;
  }

  // State field(s) for cvv widget.
  FocusNode? cvvFocusNode;
  TextEditingController? cvvTextController;
  String? Function(BuildContext, String?)? cvvTextControllerValidator;
  String? _cvvTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'CVV es obligatorio';
    }

    if (val.length < 3) {
      return 'CVV no valida';
    }
    if (val.length > 4) {
      return 'CVV no valida';
    }

    return null;
  }

  // Stores action output result for [Custom Action - getAcceptanceToken] action in Button widget.
  dynamic acceptanceResult;
  // Stores action output result for [Custom Action - tokenizeCard] action in Button widget.
  dynamic tokenizeResult;
  // Stores action output result for [Custom Action - createPaymentSource] action in Button widget.
  dynamic paymentSourceResult;

  @override
  void initState(BuildContext context) {
    titularTextControllerValidator = _titularTextControllerValidator;
    numeroTarjetaTextControllerValidator =
        _numeroTarjetaTextControllerValidator;
    fechaVencTextControllerValidator = _fechaVencTextControllerValidator;
    cvvTextControllerValidator = _cvvTextControllerValidator;
  }

  @override
  void dispose() {
    titularFocusNode?.dispose();
    titularTextController?.dispose();

    numeroTarjetaFocusNode?.dispose();
    numeroTarjetaTextController?.dispose();

    fechaVencFocusNode?.dispose();
    fechaVencTextController?.dispose();

    cvvFocusNode?.dispose();
    cvvTextController?.dispose();
  }
}
