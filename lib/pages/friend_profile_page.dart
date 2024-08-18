import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:me_fit/controllers/auth.dart';
import 'package:me_fit/controllers/database_controller.dart';
import 'package:me_fit/pages/friends_activity_page.dart';
import 'package:me_fit/utilities/user_info.dart';

import '../controllers/achievements_controller.dart';
import '../controllers/theme_controller.dart';
import '../main.dart';
import '../utilities/achievement.dart';
import '../utilities/widgets/achievement_widget.dart';
import '../utilities/widgets/line_chart_widget.dart';
import 'achievements_page.dart';
import 'insights_page.dart';
import 'models/friend_profile_model.dart';
export 'models/friend_profile_model.dart';

class FriendProfilePage extends StatefulWidget {
  FriendProfilePage({super.key, required this.userData, required this.profileImage, required this.userStats});
  Map userData;
  Image profileImage;
  UserInfo userStats;

  @override
  State<FriendProfilePage> createState() => _FriendProfileWidgetState();
}

class _FriendProfileWidgetState extends State<FriendProfilePage>
    with TickerProviderStateMixin {
  late FriendProfileModel _model;

  String stepsTimeClass = 'D';

  List<int> stepsData = [];
  List<DateTime> stepsDates = [];

  late Achievement achievement1;
  late Achievement achievement2;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FriendProfileModel());

    var x = AchievementsController.get2RandomAchievementsFrom(widget.userStats.achievementsDates);
    achievement1 = x[0];
    achievement2 = x[1];

    updateStepsLineData();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void updateStepsLineData() {
    var now = DateTime.now();
    var base = DateTime(now.year, now.month, now.day);
    List<DateTime> timeSeparators = [];
    for (int i = 5 ; i > 0 ; i--) {
      if (stepsTimeClass == "D") {
        timeSeparators.add(base.subtract(Duration(days: i)));
      } else if (stepsTimeClass == "W") {
        timeSeparators.add(base.subtract(Duration(days: i * 7)));
      } else {
        timeSeparators.add(base.subtract(Duration(days: i * 30)));
      }
    }
    timeSeparators.add(DateTime.now());
    List<DateTime> stepsDates_ = [];
    widget.userStats.stepsDateTimeline.forEach((element) {
      stepsDates_.add(DateTime.fromMillisecondsSinceEpoch(element));
    });
    var regions = InsightsPageState.findIndicesBetweenTimeSeparators(timeSeparators, stepsDates_);
    stepsData = List.filled(timeSeparators.length - 1, 0);
    stepsDates = timeSeparators.sublist(0, timeSeparators.length - 1);

    for (int i = 0 ; i < timeSeparators.length - 1 ; i++) { // loop for x axis of the graph
      for (int j = 0 ; j < regions.length ; j++) {
        if (regions[j].isNotEmpty && timeSeparators[i].millisecondsSinceEpoch <= stepsDates_[regions[j][0]].millisecondsSinceEpoch &&
            timeSeparators[i+1].millisecondsSinceEpoch > stepsDates_[regions[j][1]].millisecondsSinceEpoch) {
          if (regions[j][0] == regions[j][1]) {
            stepsData[i] = widget.userStats.stepsCountTimeline[regions[j][0]];
          } else {
            stepsData[i] = Main.countSteps(widget.userStats.stepsCountTimeline, regions[j][0], regions[j][1]);
          }
          regions.removeAt(j);
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: SingleChildScrollView(
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
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0, 1),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    24, 25, 0, 13),
                                child: Container(
                                  width: 127,
                                  height: 127,
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
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image(
                                          image: widget.profileImage.image,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
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
                      Align(
                        alignment: const AlignmentDirectional(0, -1),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                          child: Text(
                            widget.userData['firstName'] + ' ' + widget.userData['lastName'],
                            style: FlutterFlowTheme.of(context)
                                .headlineLarge
                                .override(
                              fontFamily: 'Outfit',
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, -1),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(24, 4, 0, 16),
                          child: Text(
                            widget.userData['username'],
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                        child: Container(
                          width: double.infinity,
                          height: 167,
                          decoration: const BoxDecoration(
                            color: Color(0xC014181B),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 0, 0, 0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/bonfire.png',
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0, 40, 0, 0),
                                      child: Text(
                                        'has a streak of',
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                          fontFamily: 'Montserrat',
                                          letterSpacing: 0,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0, 20, 0, 0),
                                      child: Text(
                                        '${widget.userStats.streakSeq.length} days',
                                        style: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .override(
                                          fontFamily: 'Montserrat',
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(12, 20, 12, 0),
                        child: Container(
                          width: double.infinity,
                          // height: 400,
                          decoration: const BoxDecoration(
                            color: Color(0xB014181B),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
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
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AchievementsPage(achievementsDates: widget.userStats.achievementsDates)));
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
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 0),
                        child: Container(
                          width: double.infinity,
                          height: 420,
                          decoration: const BoxDecoration(
                            color: Color(0x9314181B),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(13),
                              bottomRight: Radius.circular(13),
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(13),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 13, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Align(
                                  alignment: const AlignmentDirectional(-1, -1),
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        12, 0, 0, 12),
                                    child: Text(
                                      'Summary of taken steps',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: 'Readex Pro',
                                        letterSpacing: 0,
                                        fontStyle: FontStyle.italic,
                                        decoration:
                                        TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: FastSegmentedControl<String>(
                                    name: 'segmented_control',
                                    onChanged: (text) {
                                      setState(() {
                                        stepsTimeClass = text!;
                                        updateStepsLineData();
                                      });
                                    },
                                    initialValue: stepsTimeClass,
                                    children: {
                                      "D" : Text('Daily', style: TextStyle(color: ThemeController.getPrimaryTextColor())),
                                      "W" : Text('Weekly', style: TextStyle(color: ThemeController.getPrimaryTextColor())),
                                      "M" : Text('Monthly', style: TextStyle(color: ThemeController.getPrimaryTextColor())),
                                    },
                                  ),
                                ),
                                LineChartWidget(yLabel: 'Steps', data: stepsData, dates: stepsDates),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                          child: FFButtonWidget(
                            onPressed: () async {
                              await DatabaseController.unfriend(Auth().currentUser!.email ?? '', widget.userData['email']);
                              FriendsActivityPageState.currState.updateFriends();
                              Navigator.of(context).pop();
                            },
                            text: 'Unfriend',
                            options: FFButtonOptions(
                              height: 40,
                              padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                              iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: const Color(0xFFFC6C02),
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                fontFamily: 'Readex Pro',
                                color: FlutterFlowTheme.of(context)
                                    .primaryText,
                                letterSpacing: 0,
                              ),
                              elevation: 3,
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 0, 0),
                child: FlutterFlowIconButton(
                  borderColor: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: 20,
                  borderWidth: 1,
                  buttonSize: 40,
                  fillColor: const Color(0x841D2428),
                  icon: Icon(
                    Icons.chevron_left_sharp,
                    color: FlutterFlowTheme.of(context).primaryText,
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
