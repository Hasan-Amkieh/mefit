import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:me_fit/controllers/auth.dart';
import 'package:me_fit/controllers/theme_controller.dart';
import 'package:flutter/material.dart';

import '../controllers/database_controller.dart';
import '../main.dart';
import 'models/notifications_page_model.dart';
export 'models/notifications_page_model.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  late NotificationsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  static NotificationsPageState? currState;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationsPageModel());
    currState = this;
  }

  @override
  void dispose() {
    _model.dispose();
    currState = null;

    super.dispose();
  }

  List<Widget> widgets = [];

  @override
  Widget build(BuildContext context) {
    widgets = [];
    for (int i = 0 ; i < Main.incomingInvitations.length ; i++) {
      List<String> user = Main.incomingInvitations[i];
      widgets.add(Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ThemeController.getPrimaryBackgroundColor(),
            boxShadow: const [
              BoxShadow(
                blurRadius: 3,
                color: Color(0x33000000),
                offset: Offset(
                  0,
                  1,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFC6C02),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xB2FC6C02),
                      width: 2,
                    ),
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Icon(
                      Icons.person_add_rounded,
                      color: ThemeController.getPrimaryBackgroundColor(),
                      size: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 4, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Friend Request',
                          maxLines: 1,
                          style: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                            fontFamily: 'Readex Pro',
                            letterSpacing: 0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 4, 0, 0),
                          child: Text(
                            'requested to be friends.',
                            maxLines: 2,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context)
                                  .primaryText,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 12, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                    FlutterFlowTheme.of(context)
                                        .alternate,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    child: Image(
                                      image: Main.incomingInvitationsProfileImages[i].image,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    12, 0, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user[2],
                                      style:
                                      FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                        fontFamily:
                                        'Readex Pro',
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional
                                          .fromSTEB(0, 4, 0, 0),
                                      child: Text(
                                        user[1],
                                        style: FlutterFlowTheme.of(
                                            context)
                                            .labelSmall
                                            .override(
                                          fontFamily:
                                          'Readex Pro',
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 235,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: Color(0x0014181B),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FFButtonWidget(
                                onPressed: () async {
                                  await DatabaseController.acceptInvitation(Auth().currentUser!.email ?? '', Main.incomingInvitations[i][0]);
                                },
                                text: 'Accept',
                                options: FFButtonOptions(
                                  height: 40,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: const Color(0xB014181B),
                                  textStyle:
                                  FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                    letterSpacing: 0,
                                  ),
                                  elevation: 3,
                                  borderSide: BorderSide(
                                    color:
                                    FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    width: 1,
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () async {
                                  await DatabaseController.deleteInvitation(Auth().currentUser!.email ?? '', Main.incomingInvitations[i][0]);
                                },
                                text: 'Decline',
                                options: FFButtonOptions(
                                  height: 40,
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: const Color(0xB014181B),
                                  textStyle:
                                  FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                    letterSpacing: 0,
                                  ),
                                  elevation: 3,
                                  borderSide: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 8, 0, 4),
                          child: Text(
                              Main.incomingInvitationsTimes[i].difference(DateTime.now()).inHours.abs() == 0 ? 'Just now' :
                            '${Main.incomingInvitationsTimes[i].difference(DateTime.now()).inHours.abs()} hours ago',
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context)
                                  .secondaryText,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: ThemeController.getSecondaryBackgroundColor(),
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
          title: Text(
            'Notifications',
            style: ThemeController.getTitleLargeFont().override(
              fontFamily: 'Outfit',
              letterSpacing: 0,
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/MeFit_Icon.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
            ListView(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 44,
              ),
              scrollDirection: Axis.vertical,
              children: widgets.isEmpty ? [
                Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 200, 0, 0),
                        child: Text('Wow, such empty!', style: ThemeController.getBodyLargeFont(),)
                    )
                ),
              ] :
              widgets.divide(const SizedBox(height: 8)),
            ),
          ],
        ),
      ),
    );
  }
}
