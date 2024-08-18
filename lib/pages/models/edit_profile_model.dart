import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../edit_profile_page.dart' show EditProfilePage;
import 'package:flutter/material.dart';

class EditProfileModel extends FlutterFlowModel<EditProfilePage> {

  FocusNode? yourNameFocusNode1;
  TextEditingController? yourNameTextController1;
  FocusNode? usernameFocusNode;
  TextEditingController? usernameController;
  FocusNode? yourNameFocusNode12;
  TextEditingController? yourNameTextController12;
  String? Function(BuildContext, String?)? yourNameTextController1Validator;

  FocusNode? yourNameFocusNode2;
  TextEditingController? yourNameTextController2;
  String? Function(BuildContext, String?)? yourNameTextController2Validator;
  // State field(s) for weight widget.
  FocusNode? weightFocusNode;
  TextEditingController? weightTextController;
  String? Function(BuildContext, String?)? weightTextControllerValidator;
  // State field(s) for Height widget.
  FocusNode? heightFocusNode;
  TextEditingController? heightTextController;
  String? Function(BuildContext, String?)? heightTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    yourNameFocusNode1?.dispose();
    yourNameTextController1?.dispose();

    yourNameFocusNode12?.dispose();
    yourNameTextController12?.dispose();

    yourNameFocusNode2?.dispose();
    yourNameTextController2?.dispose();

    weightFocusNode?.dispose();
    weightTextController?.dispose();

    heightFocusNode?.dispose();
    heightTextController?.dispose();
  }
}
