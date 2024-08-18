import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../today_schedule_page.dart' show TodaySchedulePage;
import 'package:flutter/material.dart';

class TodayScheduleModel extends FlutterFlowModel<TodaySchedulePage> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
