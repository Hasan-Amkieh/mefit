import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../insights_page.dart' show InsightsPage;
import 'package:flutter/material.dart';

class InsightsModel extends FlutterFlowModel<InsightsPage> {

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
