import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:me_fit/controllers/database_controller.dart';
import 'package:me_fit/pages/home_page.dart';

import '../controllers/auth.dart';
import '../controllers/theme_controller.dart';
import '../main.dart';
import 'models/edit_profile_model.dart';
export 'models/edit_profile_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => EditOProfilePageState();
}

class EditOProfilePageState extends State<EditProfilePage> {
  late EditProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String sex = 'Male';
  String country = 'Turkey';
  List<String> countries = [];
  DateTime? dateOfBirth;
  Image image_ = Main.profilePhoto;
  XFile? chosenImage;

  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProfileModel());

    rootBundle.loadString('assets/data/countries.txt').then((text) {
      setState(() {
        text.split('\n').forEach((country) {
          countries.add(country.trim());
        });
      });
    });

    _model.yourNameTextController1 ??= TextEditingController(text: Main.firstName ?? '');
    _model.yourNameFocusNode1 ??= FocusNode();
    _model.yourNameTextController12 ??= TextEditingController(text: Main.lastName ?? '');
    _model.yourNameFocusNode12 ??= FocusNode();

    _model.usernameController ??= TextEditingController(text: Main.username ?? '');
    _model.usernameFocusNode ??= FocusNode();

    _model.weightTextController ??= TextEditingController(text: Main.weight.toString());
    _model.weightFocusNode ??= FocusNode();

    _model.heightTextController ??= TextEditingController(text: Main.height.toString());
    _model.heightFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        flexibleSpace: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 20, 0, 0),
            child: FlutterFlowIconButton(
              borderColor: ThemeController.getSecondaryBackgroundColor(),
              borderRadius: 20,
              borderWidth: 1,
              buttonSize: 40,
              icon: Icon(
                Icons.chevron_left_sharp,
                color: ThemeController.getPrimaryTextColor(),
                size: 24,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).alternate,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: GestureDetector(
                          onTap: () async {
                            final XFile? imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                            chosenImage = imageFile;
                            if (imageFile != null) {
                              imageFile.readAsBytes().then((value) => setState(() {
                                image_ = Image.memory(
                                  value,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                );
                              }));
                            }
                          },
                          child: Container(
                            width: 90,
                            height: 90,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: image_,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                child: TextFormField(
                  controller: _model.usernameController,
                  focusNode: _model.usernameFocusNode,
                  textCapitalization: TextCapitalization.words,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Readex Pro',
                      letterSpacing: 0,
                    ),
                    hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Readex Pro',
                      letterSpacing: 0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    letterSpacing: 0,
                  ),
                  validator: _model.yourNameTextController1Validator
                      .asValidator(context),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                child: TextFormField(
                  controller: _model.yourNameTextController1,
                  focusNode: _model.yourNameFocusNode1,
                  textCapitalization: TextCapitalization.words,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Readex Pro',
                      letterSpacing: 0,
                    ),
                    hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Readex Pro',
                      letterSpacing: 0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    letterSpacing: 0,
                  ),
                  validator: _model.yourNameTextController1Validator
                      .asValidator(context),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                child: TextFormField(
                  controller: _model.yourNameTextController12,
                  focusNode: _model.yourNameFocusNode12,
                  textCapitalization: TextCapitalization.words,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Readex Pro',
                      letterSpacing: 0,
                    ),
                    hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Readex Pro',
                      letterSpacing: 0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    letterSpacing: 0,
                  ),
                  validator: _model.yourNameTextController1Validator
                      .asValidator(context),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                child: TextFormField(
                  controller: _model.weightTextController,
                  focusNode: _model.weightFocusNode,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Weight in Kg',
                    labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Readex Pro',
                      letterSpacing: 0,
                    ),
                    hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Readex Pro',
                      letterSpacing: 0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    letterSpacing: 0,
                  ),
                  validator:
                  _model.weightTextControllerValidator.asValidator(context),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                child: TextFormField(
                  controller: _model.heightTextController,
                  focusNode: _model.heightFocusNode,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Height in Cm',
                    labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Readex Pro',
                      letterSpacing: 0,
                    ),
                    hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Readex Pro',
                      letterSpacing: 0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: const  EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    letterSpacing: 0,
                  ),
                  validator:
                  _model.heightTextControllerValidator.asValidator(context),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                child: DropdownButton<String>(
                  value: country,
                  items: countries.map<DropdownMenuItem<String>>((c) {
                    return DropdownMenuItem(
                      value: c,
                      onTap: () {
                        setState(() {
                          country = c;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/countries/$c.png',
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                            ),
                            const SizedBox(width: 8,),
                            Flexible(
                              child: Text(
                                  c
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    ;
                  },
                ),
              ),
              Visibility(
                visible: errorMsg.isNotEmpty,
                child: Text(
                  errorMsg,
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, 0.05),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 12),
                  child: FFButtonWidget(
                    onPressed: () async { // doesUserNameExist
                      if ((errorMsg.isEmpty || errorMsg == 'Username already exists!') && _model.usernameController.text != Main.username) {
                        if (await DatabaseController.doesUserNameExist(_model.usernameController.text)) {
                          setState(() {
                            errorMsg = 'Username already exists!';
                          });
                          return ;
                        } else {
                          errorMsg = '';
                        }
                      }
                      if (errorMsg == 'Username already exists!' && _model.usernameController.text == Main.username) {
                        errorMsg = '';
                      }

                      if (errorMsg.isEmpty) {
                        await DatabaseController.updateUserInfo(Auth().currentUser?.email ?? '',
                          _model.usernameController.text,
                          _model.yourNameTextController1.text, _model.yourNameTextController12.text,
                          double.parse(_model.weightTextController.text),
                          double.parse(_model.heightTextController.text),
                          country,
                        );
                        chosenImage != null ? await DatabaseController.updateProfileImage(Auth().currentUser!.email ?? '', File(chosenImage!.path)) : null;
                        Main.profilePhoto = image_;
                        Main.profilePhotoName = DatabaseController.formatEmail(Auth().currentUser!.email ?? '');
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                          return const HomePage();
                        })
                        );
                      }
                    },
                    text: 'Update',
                    options: FFButtonOptions(
                      width: 270,
                      height: 50,
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: const Color(0xFFF34E3A),
                      textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                      elevation: 2,
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
