import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../view_schedule_page.dart' show ViewSchedulePage;
import 'package:flutter/material.dart';

class SchedulePreviewModel extends FlutterFlowModel<ViewSchedulePage> {

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
