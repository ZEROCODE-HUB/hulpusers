import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'mistarjetas_widget.dart' show MistarjetasWidget;
import 'package:flutter/material.dart';

class MistarjetasModel extends FlutterFlowModel<MistarjetasWidget> {
  ///  State fields for stateful widgets in this page.

  Stream<List<TarjetasGuardadasRow>>? containerSupabaseStream;
  // Stores action output result for [Backend Call - Delete Row(s)] action in IconButton widget.
  List<TarjetasGuardadasRow>? delete;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
