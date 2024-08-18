import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../profile_page.dart' show ProfilePage;
import 'package:flutter/material.dart';

class ProfileModel extends FlutterFlowModel<ProfilePage> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
