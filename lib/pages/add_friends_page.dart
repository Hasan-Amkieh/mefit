import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:me_fit/controllers/database_controller.dart';
import 'package:me_fit/controllers/theme_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'models/add_friends_model.dart';
export 'models/add_friends_model.dart';

class AddFriendsPage extends StatefulWidget {
  const AddFriendsPage({super.key});

  @override
  State<AddFriendsPage> createState() => _FriendListAddWidgetState();
}

class _FriendListAddWidgetState extends State<AddFriendsPage> {
  late AddFriendsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<List<String>> users = [];
  List<bool> checkboxValues = [];
  List<Image> profilePhotos = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddFriendsModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: ThemeController.getPrimaryTextColor(),
              size: 30,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/MeFit_Icon.png',
              ),
            ),
          ),
          centerTitle: false,
          elevation: 2,
        ),
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Invite your friends to join you!',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Readex Pro',
                    letterSpacing: 0,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                              child: TextFormField(
                                controller: _model.textController1,
                                onChanged: (text) {
                                  if (text.isNotEmpty) {
                                    DatabaseController.searchByUsername(text).then((value) async {
                                      users = value;
                                      checkboxValues = List.filled(users.length, false);
                                      profilePhotos = [];
                                      for (List<String> user in users) {
                                        profilePhotos.add(await DatabaseController.retreiveImageWidget(user[0]));
                                      }
                                      setState(() {});
                                    });
                                  } else {
                                    setState(() {
                                      users = [];
                                      checkboxValues = [];
                                      profilePhotos = [];
                                    });
                                  }
                                },
                                focusNode: _model.textFieldFocusNode1,
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Search by username...',
                                  labelStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0,
                                  ),
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                      FlutterFlowTheme.of(context).tertiary,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsetsDirectional.fromSTEB(
                                      24, 16, 0, 16),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0,
                                ),
                                validator: _model.textController1Validator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                          FlutterFlowIconButton(
                            borderColor: FlutterFlowTheme.of(context).alternate,
                            borderRadius: 20,
                            borderWidth: 1,
                            buttonSize: 40,
                            fillColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            icon: Icon(
                              Icons.clear,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                _model.textController1.text = "";
                                users = [];
                                checkboxValues = [];
                                profilePhotos = [];
                              });
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                        child: LinearPercentIndicator(
                          percent: 1,
                          width: MediaQuery.sizeOf(context).width,
                          lineHeight: 12,
                          animation: true,
                          animateFromLastPercent: true,
                          progressColor: const Color(0xCFF37F3A),
                          backgroundColor: const Color(0xFFE0E3E7),
                          barRadius: const Radius.circular(0),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: ListView.builder(
                    itemCount: users.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: FlutterFlowTheme.of(context).alternate,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image(
                                        image: profilePhotos[index].image,
                                        width: 44,
                                        height: 44,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor:
                                    FlutterFlowTheme.of(context)
                                        .secondaryText,
                                  ),
                                  child: CheckboxListTile(
                                    value: checkboxValues[index],
                                    onChanged: (newValue) async {
                                      setState(() => checkboxValues[index] = newValue!);
                                    },
                                    title: Text(
                                      users[index][1],
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                        fontFamily: 'Readex Pro',
                                        letterSpacing: 0,
                                        lineHeight: 2,
                                      ),
                                    ),
                                    subtitle: Text(
                                      users[index][2],
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                        fontFamily: 'Readex Pro',
                                        color: const Color(0xFFF37F3A),
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    tileColor: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    activeColor: const Color(0xFFF34E3A),
                                    checkColor: Colors.white,
                                    dense: false,
                                    controlAffinity:
                                    ListTileControlAffinity.trailing,
                                    contentPadding: const EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 8, 0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: const AlignmentDirectional(0, 1),
              child: Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).accent4,
                      FlutterFlowTheme.of(context).secondaryBackground
                    ],
                    stops: const [0, 1],
                    begin: const AlignmentDirectional(0, -1),
                    end: const AlignmentDirectional(0, 1),
                  ),
                ),
                alignment: const AlignmentDirectional(0, 0),
                child: FFButtonWidget(
                  onPressed: () async {
                    List<String> emails = [];
                    for (int i = 0 ; i < users.length ; i++) {
                      if (checkboxValues[i]) {
                        emails.add(users[i][0]);
                      }
                    }
                    await DatabaseController.sendInvitations(emails);
                    Navigator.of(context).pop();
                  },
                  text: 'Send Invites',
                  options: FFButtonOptions(
                    width: 270,
                    height: 50,
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: const Color(0xFFF34E3A),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                    elevation: 2,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
