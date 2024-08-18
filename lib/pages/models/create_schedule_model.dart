import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../create_schedule_page.dart' show CreateSchedulePage;
import 'package:flutter/material.dart';

class CreateScheduleModel extends FlutterFlowModel<CreateSchedulePage> {

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
