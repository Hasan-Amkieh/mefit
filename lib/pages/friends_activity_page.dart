import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:me_fit/controllers/database_controller.dart';
import 'package:me_fit/pages/add_friends_page.dart';

import '../controllers/auth.dart';
import '../controllers/theme_controller.dart';
import 'models/friends_activity_model.dart';
export 'models/friends_activity_model.dart';
import 'package:me_fit/pages/friend_profile_page.dart';

class FriendsActivityPage extends StatefulWidget {
  const FriendsActivityPage({super.key});

  @override
  State<FriendsActivityPage> createState() => FriendsActivityPageState();
}

class FriendsActivityPageState extends State<FriendsActivityPage> {
  late FriendsActivityModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FriendsActivityModel());
    currState = this;

    updateFriends();
  }

  void updateFriends() {
    DatabaseController.getFriends(Auth().currentUser!.email ?? '').then((value) async {
      friends = value;
      for (int i = 0 ; i < friends.length ; i++) {
        print(friends[i]['email']);
        friendsImages.add(await DatabaseController.retreiveImageWidget(friends[i]['email']));
      }
      setState(() {});
    });
  }

  List<Map> friends = [];
  List<Image> friendsImages = [];

  static late FriendsActivityPageState currState;

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
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
              color: FlutterFlowTheme.of(context).primaryText,
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
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Friends List',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                        fontFamily: 'Outfit',
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              var userInfo = await DatabaseController.getUserStatistics(friends[index]['email']);
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                  FriendProfilePage(userData: friends[index],
                                      profileImage: friendsImages[index],
                                      userStats: userInfo)));
                            },
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      child: Image(
                                        image: friendsImages[index].image,
                                        width: 70,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(-1, -1),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                      child: Text(
                                        "${friends[index]['firstName'] + ' ' + friends[index]['lastName']}\n${friends[index]['username']}",
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '                                ',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily: 'Readex Pro',
                                      letterSpacing: 0,
                                    ),
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(0, -1),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                      child: Icon(
                                        Icons.arrow_right_sharp,
                                        color:
                                        FlutterFlowTheme.of(context).secondaryText,
                                        size: 32,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: FFButtonWidget(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddFriendsPage()));
                    },
                    text: 'Add Friends',
                    options: FFButtonOptions(
                      width: 150,
                      height: 44,
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: const Color(0xCFF37F3A),
                      textStyle: ThemeController.getBodyMediumFont().override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(38),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
