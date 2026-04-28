import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'terminosycondiciones_copy_widget.dart'
    show TerminosycondicionesCopyWidget;
import 'package:flutter/material.dart';

class TerminosycondicionesCopyModel
    extends FlutterFlowModel<TerminosycondicionesCopyWidget> {
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
