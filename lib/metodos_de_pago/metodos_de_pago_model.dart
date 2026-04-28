import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'metodos_de_pago_widget.dart' show MetodosDePagoWidget;
import 'package:flutter/material.dart';

class MetodosDePagoModel extends FlutterFlowModel<MetodosDePagoWidget> {
  ///  Local state fields for this page.

  String? metodoPago;

  ///  State fields for stateful widgets in this page.

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
