import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../exercise_page.dart' show ExercisePage;
import 'package:flutter/material.dart';

class Schedule2Model extends FlutterFlowModel<ExercisePage> {

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
