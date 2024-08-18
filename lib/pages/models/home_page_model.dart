import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../home_page.dart' show HomePage;
import 'package:flutter/material.dart';

class HomeModel extends FlutterFlowModel<HomePage> {
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {

  }

  @override
  void dispose() {
    unfocusNode.dispose();
  }

}
