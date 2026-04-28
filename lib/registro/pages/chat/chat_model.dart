import '/backend/supabase/supabase.dart';
import '/components/mensajes_chat_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'chat_widget.dart' show ChatWidget;
import 'package:flutter/material.dart';

class ChatModel extends FlutterFlowModel<ChatWidget> {
  ///  Local state fields for this page.

  String? ultimoMensaje;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in Chat widget.
  List<ChatsSolicitudRow>? chatDato;
  Stream<List<ChatsSolicitudRow>>? containerSupabaseStream1;
  Stream<List<MensajesChatRow>>? containerSupabaseStream2;
  // State field(s) for ListView widget.
  ScrollController? listViewController;
  // Models for MensajesChat dynamic component.
  late FlutterFlowDynamicModels<MensajesChatModel> mensajesChatModels;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {
    listViewController = ScrollController();
    mensajesChatModels = FlutterFlowDynamicModels(() => MensajesChatModel());
  }

  @override
  void dispose() {
    listViewController?.dispose();
    mensajesChatModels.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
