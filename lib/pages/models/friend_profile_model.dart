import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../friend_profile_page.dart' show FriendProfilePage;
import 'package:flutter/material.dart';

class FriendProfileModel extends FlutterFlowModel<FriendProfilePage> {
  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
