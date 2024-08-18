import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../friends_activity_page.dart' show FriendsActivityPage;
import 'package:flutter/material.dart';

class FriendsActivityModel extends FlutterFlowModel<FriendsActivityPage> {

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
