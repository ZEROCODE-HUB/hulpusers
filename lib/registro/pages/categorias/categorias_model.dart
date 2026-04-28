import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'categorias_widget.dart' show CategoriasWidget;
import 'package:flutter/material.dart';

class CategoriasModel extends FlutterFlowModel<CategoriasWidget> {
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
