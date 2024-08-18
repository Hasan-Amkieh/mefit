import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../fill_profile_info_page.dart' show FillProfileInfoPage;
import 'package:flutter/material.dart';

class FillProfileInfoModel extends FlutterFlowModel<FillProfileInfoPage> {

  // State field(s) for yourName widget.
  FocusNode? yourNameFocusNode1;
  TextEditingController? yourNameTextController1;
  FocusNode? usernameFocusNode;
  TextEditingController? usernameController;
  FocusNode? yourNameFocusNode12;
  TextEditingController? yourNameTextController12;
  String? Function(BuildContext, String?)? yourNameTextController1Validator;

  FocusNode? ageFocusNode;
  TextEditingController? ageTextController;

  // State field(s) for yourName widget.
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

    ageTextController?.dispose();
    ageFocusNode?.dispose();

    yourNameFocusNode2?.dispose();
    yourNameTextController2?.dispose();

    weightFocusNode?.dispose();
    weightTextController?.dispose();

    heightFocusNode?.dispose();
    heightTextController?.dispose();
  }
}
