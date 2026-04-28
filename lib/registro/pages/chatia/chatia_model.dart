import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import '/index.dart';
import 'chatia_widget.dart' show ChatiaWidget;
import 'package:flutter/material.dart';

class ChatiaModel extends FlutterFlowModel<ChatiaWidget> {
  ///  Local state fields for this page.

  String? ultimomensaje;

  ///  State fields for stateful widgets in this page.

  Stream<List<ConversacionesRow>>? containerSupabaseStream;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - Query Rows] action in Icon widget.
  List<TarjetasGuardadasRow>? tarjetas22;
  // Stores action output result for [Backend Call - API (IA NochoN)] action in Icon widget.
  ApiCallResponse? apiResult6wt;
  // Model for MenuBar component.
  late MenuBarModel menuBarModel;

  @override
  void initState(BuildContext context) {
    menuBarModel = createModel(context, () => MenuBarModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    menuBarModel.dispose();
  }
}
