import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:me_fit/controllers/achievements_controller.dart';
import 'package:me_fit/controllers/auth.dart';
import 'package:me_fit/controllers/theme_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:me_fit/pages/achievements_page.dart';
import 'package:me_fit/pages/edit_profile_page.dart';
import 'package:me_fit/pages/friends_activity_page.dart';
import 'package:me_fit/pages/login_page.dart';
import 'package:me_fit/utilities/achievement.dart';
import 'package:me_fit/utilities/widgets/achievement_widget.dart';

import '../controllers/database_controller.dart';
import '../main.dart';
import 'models/profile_page_model.dart';
export 'models/profile_page_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late ProfileModel _model;
  late Achievement achievement1;
  late Achievement achievement2;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'buttonOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 400.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 600.ms,
          begin: const Offset(0, 60),
          end: const Offset(0, 0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileModel());
    var x = AchievementsController.get2RandomAchievementsFrom(Main.achievementsDates);
    achievement1 = x[0];
    achievement2 = x[1];

    setupAnimations(
      animationsMap.values.where((anim) =>
      anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => _model.unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(_model.unfocusNode)
            : FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: ThemeController.getPrimaryBackgroundColor(),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, -1.07),
                            child: Container(
                              width: double.infinity,
                              height: 460,
                              decoration: BoxDecoration(
                                color: ThemeController.getSecondaryBackgroundColor(),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(0, 1),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(24, 25, 0, 16),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: const Color(0xCFF37F3A),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFF34E3A),
                                    width: 2,
                                  ),
                                ),
                                alignment: const AlignmentDirectional(0, -1),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image(
                                        image: Main.profilePhoto.image,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                      child: Text(
                        '${Main.firstName} ${Main.lastName}',
                        style:
                        ThemeController.getHeadlineLargeFont().override(
                          fontFamily: 'Outfit',
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 16),
                      child: Text(
                        Main.username ?? '',
                        style: ThemeController.getLabelMediumFont().override(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 0),
                      child: Text(
                        'Your Account',
                        style: ThemeController.getLabelMediumFont().override(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: ThemeController.getSecondaryBackgroundColor(),
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
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditProfilePage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.account_circle_outlined,
                                  color: ThemeController.getSecondaryTextColor(),
                                  size: 24,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                  child: Text(
                                    'Edit Profile',
                                    style: ThemeController.getLabelLargeFont().override(
                                      fontFamily: 'Readex Pro',
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: const AlignmentDirectional(0.9, 0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: ThemeController.getSecondaryTextColor(),
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: ThemeController.getSecondaryBackgroundColor(),
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
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FriendsActivityPage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.people_alt_sharp,
                                  color: ThemeController.getSecondaryTextColor(),
                                  size: 24,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                  child: Text(
                                    'Friends Activity',
                                    style: ThemeController.getLabelLargeFont()
                                        .override(
                                      fontFamily: 'Readex Pro',
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: const AlignmentDirectional(0.9, 0),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: ThemeController.getSecondaryTextColor(),
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(12, 20, 12, 0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: ThemeController.getSecondaryBackgroundColor(),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'See All Achievements',
                                    style: ThemeController.getBodyMediumFont()
                                        .override(
                                      fontFamily: 'PT Sans',
                                      letterSpacing: 0,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_right_alt,
                                    color: ThemeController.getSecondaryTextColor(),
                                    size: 24,
                                  )
                                ],//////
                              ),
                              onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AchievementsPage(achievementsDates: Main.achievementsDates)));
                                },
                            ),
                            AchievementWidget(
                                achievement: achievement1,
                            ),
                            AchievementWidget(
                              achievement: achievement2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                        child: FFButtonWidget(
                          onPressed: () async {
                            await DatabaseController.writeAllFields(Auth().currentUser!.email ?? '');
                            Main.savedData.clear();
                            await Auth().signOut();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                          text: 'Log Out',
                          options: FFButtonOptions(
                            width: 150,
                            height: 44,
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: const Color(0xCFF37F3A),
                            textStyle:
                            ThemeController.getBodyMediumFont().override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                            elevation: 0,
                            borderRadius: BorderRadius.circular(38),
                          ),
                        ).animateOnPageLoad(
                            animationsMap['buttonOnPageLoadAnimation']!),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 0, 0),
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
            ],
          ),
        ),
      ),
    );
  }
}
