import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../schedule_preview_page.dart' show SchedulePreviewPage;
import 'package:flutter/material.dart';

class SchedulePreviewModel extends FlutterFlowModel<SchedulePreviewPage> {

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
