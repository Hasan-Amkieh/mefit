import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../groceries_search_page.dart';
import '../groceries_search_page.dart' show GroceriesSearchPage;
import 'package:flutter/material.dart';

class GroceriesSearchPageModel extends FlutterFlowModel<GroceriesSearchPage> {

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
