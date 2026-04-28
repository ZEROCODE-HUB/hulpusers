import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'terminosycondiciones_widget.dart' show TerminosycondicionesWidget;
import 'package:flutter/material.dart';

class TerminosycondicionesModel
    extends FlutterFlowModel<TerminosycondicionesWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for MenuBar component.
  late MenuBarModel menuBarModel;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
  }

  @override
  void dispose() {
    menuBarModel.dispose();
  }
}
