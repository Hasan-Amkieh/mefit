import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../choose_workout_page.dart' show ChooseWorkoutPage;
import 'package:flutter/material.dart';

class ChooseWorkoutPageModel extends FlutterFlowModel<ChooseWorkoutPage> {

  final unfocusNode = FocusNode();
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
