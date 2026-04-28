import '/backend/supabase/supabase.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'miperfil_widget.dart' show MiperfilWidget;
import 'package:flutter/material.dart';

class MiperfilModel extends FlutterFlowModel<MiperfilWidget> {
  ///  State fields for stateful widgets in this page.

  Stream<List<UsuariosRow>>? containerSupabaseStream;
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
