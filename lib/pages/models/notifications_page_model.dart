import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:me_fit/pages/notifications_page.dart' show NotificationsPage;
import 'package:flutter/material.dart';

class NotificationsPageModel extends FlutterFlowModel<NotificationsPage> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
