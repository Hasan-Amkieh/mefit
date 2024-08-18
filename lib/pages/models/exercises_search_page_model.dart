import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../exercises_search_page.dart';
import '../exercises_search_page.dart' show ExercisesSearchPage;
import 'package:flutter/material.dart';

class ExercisesSearchPageModel extends FlutterFlowModel<ExercisesSearchPage> {

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
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
