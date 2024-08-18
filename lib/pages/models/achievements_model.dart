import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../achievements_page.dart' show AchievementsPage;
import 'package:flutter/material.dart';

class AchievementsModel extends FlutterFlowModel<AchievementsPage> {

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
