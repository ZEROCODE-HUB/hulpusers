import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'politicadeprivacidad_widget.dart' show PoliticadeprivacidadWidget;
import 'package:flutter/material.dart';

class PoliticadeprivacidadModel
    extends FlutterFlowModel<PoliticadeprivacidadWidget> {
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
