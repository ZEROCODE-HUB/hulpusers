import '/backend/supabase/supabase.dart';
import '/components/menu_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  String searchtext = '\"\"';

  bool notificationEnabled = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getVersion] action in HomePage widget.
  String? versionApp;
  // Stores action output result for [Custom Action - areNotificationsEnabled] action in HomePage widget.
  bool? notificacionActiva;
  // Stores action output result for [Backend Call - Query Rows] action in HomePage widget.
  List<AppVersionRow>? appversion23;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
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
