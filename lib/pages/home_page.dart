import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:me_fit/controllers/achievements_controller.dart';
import 'package:me_fit/controllers/auth.dart';
import 'package:me_fit/controllers/database_controller.dart';
import 'package:me_fit/pages/create_schedule_page.dart';
import 'package:me_fit/pages/exercises_search_page.dart';
import 'package:me_fit/pages/groceries_search_page.dart';
import 'package:me_fit/pages/insights_page.dart';
import 'package:me_fit/pages/profile_page.dart';
import 'package:me_fit/pages/schedule_generator_page.dart';
import 'package:me_fit/pages/notifications_page.dart';
import 'package:me_fit/pages/support_page.dart';
import 'package:me_fit/pages/settings_page.dart';
import 'package:me_fit/pages/today_schedule_page.dart';
import 'package:me_fit/pages/view_schedule_page.dart';
import 'package:me_fit/utilities/widgets/calendar_widget.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/notification_controller.dart';
import '../controllers/theme_controller.dart';
import '../main.dart';
import 'models/home_page_model.dart';
export 'models/home_page_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  late HomeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  static late HomePageState currState;

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 300.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 300.ms,
          begin: const Offset(0, 20),
          end: const Offset(0, 0),
        ),
        TiltEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 300.ms,
          begin: const Offset(0.698, 0),
          end: const Offset(0, 0),
        ),
      ],
    ),
  };

  static String dayTitle = "";

  @override
  void initState() {
    super.initState();
    currState = this;
    DatabaseController.initialize();
    if (Auth().currentUser?.email != null) {
      DatabaseController.retrieveUserInfo(Auth().currentUser!.email ?? '');
    }
    DatabaseController.retreiveImageWidget(Auth().currentUser!.email ?? '').then((value) => setState(() {
      Main.profilePhoto = value;
    }));

    Main.updateScheduleDay();

    Permission.activityRecognition.request().then((value) {
      Main.stepCountStream = Pedometer.stepCountStream;
      Main.stepCountStream.listen((StepCount event) {
        if (Main.stepsDateTimeline.isEmpty ||
            event.timeStamp.difference(DateTime.fromMillisecondsSinceEpoch(Main.stepsDateTimeline.last)).inMinutes > 1 &&
            Main.overallSteps != event.steps && event.steps > 0) {
          // if the new step count is older than a minute then register it:
          setState(() {
            print("Overall steps: ${event.steps}");
            Main.stepsCountTimeline.forEach((element) {
              print(element);
            });

            Main.stepsDateTimeline.forEach((element) {
              print(DateTime.fromMillisecondsSinceEpoch(element));
            });
            if (Main.stepsCountTimeline.isEmpty) {
              Main.overallSteps = event.steps;
              Main.todaySteps = event.steps;
              Main.writeAllData();
              Main.stepsCountTimeline.add(Main.overallSteps);
              Main.stepsDateTimeline.add(event.timeStamp.millisecondsSinceEpoch);
            } else { // calculate today steps
              Main.overallSteps = event.steps;
              Main.stepsCountTimeline.add(Main.overallSteps);
              Main.stepsDateTimeline.add(event.timeStamp.millisecondsSinceEpoch);
              Main.countTodaySteps();
              HomepageCalendarWidgetState.currState.setState(() {HomepageCalendarWidgetState.updateStreaks();}); // if a streak happened, we need to check
            }
            Main.writeAllData();
          });
          if (Main.todaySteps >= 5000 && Main.achievementsDates[9] == 0) {
            AchievementsController.completeAchievement(9);
          }
          if (Main.todaySteps >= 10000 && Main.achievementsDates[10] == 0) {
            AchievementsController.completeAchievement(10);
          }
          if (Main.todaySteps >= 20000 && Main.achievementsDates[11] == 0) {
            AchievementsController.completeAchievement(11);
          }

          var now = DateTime.now();
          // 4th and 5th achievement
          if (Main.lastCountDate20PercentDaysGoal.difference(now).abs().inHours >= 24) {
            if ((Main.todaySteps / Main.dailyStepsGoal) >= 0.2) {
              Main.lastCountDate20PercentDaysGoal = now;
              if (Main.startDate20PercentDaysGoal.difference(now).inDays.abs() >= 7 && Main.achievementsDates[3] == 0) {
                AchievementsController.completeAchievement(3);
              }
              if (Main.startDate20PercentDaysGoal.difference(now).inDays.abs() >= 30 && Main.achievementsDates[4] == 0) {
                AchievementsController.completeAchievement(4);
              }
            }
          } else if (Main.lastCountDate20PercentDaysGoal.difference(now).abs().inHours >= 48) {
            Main.startDate20PercentDaysGoal = now;
            Main.lastCountDate20PercentDaysGoal = now;
          }

          // 6th and 7th achievement
          if (Main.lastCountDate50PercentDaysGoal.difference(now).abs().inHours >= 24) {
            if ((Main.todaySteps / Main.dailyStepsGoal) >= 0.5) {
              Main.lastCountDate50PercentDaysGoal = now;
              if (Main.startDate50PercentDaysGoal.difference(now).inDays.abs() >= 7 && Main.achievementsDates[5] == 0) {
                AchievementsController.completeAchievement(5);
              }
              if (Main.startDate50PercentDaysGoal.difference(now).inDays.abs() >= 30 && Main.achievementsDates[6] == 0) {
                AchievementsController.completeAchievement(6);
              }
            }
          } else if (Main.lastCountDate50PercentDaysGoal.difference(now).abs().inHours >= 48) {
            Main.startDate50PercentDaysGoal = now;
            Main.lastCountDate50PercentDaysGoal = now;
          }

          // 8th and 9th achievement
          if (Main.lastCountDate100PercentDaysGoal.difference(now).abs().inHours >= 24) {
            if ((Main.todaySteps / Main.dailyStepsGoal) >= 1.0) {
              Main.lastCountDate100PercentDaysGoal = now;
              if (Main.startDate100PercentDaysGoal.difference(now).inDays.abs() >= 7 && Main.achievementsDates[7] == 0) {
                AchievementsController.completeAchievement(7);
              }
              if (Main.startDate100PercentDaysGoal.difference(now).inDays.abs() >= 30 && Main.achievementsDates[8] == 0) {
                AchievementsController.completeAchievement(8);
              }
            }
          } else if (Main.lastCountDate100PercentDaysGoal.difference(now).abs().inHours >= 48) {
            Main.startDate100PercentDaysGoal = now;
            Main.lastCountDate100PercentDaysGoal = now;
          }
        }
        AchievementsController.checkTotalStepsAchievements();
      });
    });
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    NotificationController.startReminders();

    DatabaseController.getFriendsInvitations(Auth().currentUser!.email ?? '').then((value) async {
      for (MapEntry entry in value.entries) {
        DatabaseController.retreiveImageWidget(entry.key);
        Main.incomingInvitationsTimes.add(DateTime.fromMillisecondsSinceEpoch(entry.value.toInt()));
        Main.incomingInvitationsProfileImages.add(await DatabaseController.retreiveImageWidget(entry.key));
        Map user = await DatabaseController.getUserInfo(entry.key);
        Main.incomingInvitations.add([entry.key, user['username'], user['firstName'] + ' ' + user['lastName']]);
        if (Main.incomingInvitationsTimes.last.difference(DateTime.now()).inDays.abs() <= 7) { // if the invitation is not as old as 7 days, then generate a notification
          NotificationController.generateFriendInvitation(user['username']);
        }
      }
    });

    DatabaseController.db.ref('users/${DatabaseController.formatEmail(Auth().currentUser!.email ?? '')}/incomingFriends').onValue.listen((event) async {
      Main.incomingInvitationsTimes = [];
      Main.incomingInvitationsProfileImages = [];
      Main.incomingInvitations = [];
      if (event.snapshot.value != null) {
        List<int> dates = [];
        int maxIndex = -1;
        int index = 0;
        for (MapEntry entry in (event.snapshot.value as Map).entries) {
          DatabaseController.retreiveImageWidget(entry.key);
          Main.incomingInvitationsTimes.add(DateTime.fromMillisecondsSinceEpoch(entry.value.toInt()));
          dates.add(entry.value.toInt());
          Main.incomingInvitationsProfileImages.add(await DatabaseController.retreiveImageWidget(entry.key));
          Map user = await DatabaseController.getUserInfo(entry.key);
          Main.incomingInvitations.add([entry.key, user['username'], user['firstName'] + ' ' + user['lastName']]);
          if (maxIndex == -1) {
            maxIndex = 0;
          } else if (dates[maxIndex] < entry.value.toInt()) {
            maxIndex = index;
          }
          index++;
        }
        if (maxIndex != -1) {
          Map user = await DatabaseController.getUserInfo(Main.incomingInvitations[maxIndex][0]);
          NotificationController.generateFriendInvitation(user['username']);
        }
      }
      if (NotificationsPageState.currState != null) {
        NotificationsPageState.currState!.setState(() {});
      }
    });

    _model = createModel(context, () => HomeModel());

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
    final now = DateTime.now();
    int hour = now.hour;
    String greeting;
    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 17) {
      greeting = "Good Afternoon";
    } else if (hour < 20) {
      greeting = "Good Evening";
    } else {
      greeting = "Welcome";
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: ThemeController.getPrimaryBackgroundColor(),
        drawer: Drawer(
          elevation: 16,
          child: SingleChildScrollView(
            child: Container(
              color: ThemeController.getSecondaryBackgroundColor(),
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: ThemeController.getSecondaryBackgroundColor(),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 3,
                              color: Color(0x33000000),
                              offset: Offset(0, 1),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.manage_search,
                                      color: ThemeController.getSecondaryTextColor(),
                                      size: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    Text('Exercises Search', style: ThemeController.getLabelLargeFont())
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: ThemeController.getSecondaryTextColor(),
                                  size: 18,
                                )
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ExercisesSearchPage()));
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ThemeController.getSecondaryBackgroundColor(),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 3,
                              color: Color(0x33000000),
                              offset: Offset(0, 1),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.edit_calendar_outlined,
                                      color: ThemeController.getSecondaryTextColor(),
                                      size: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    Text('Create Schedule', style: ThemeController.getLabelLargeFont()),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: ThemeController.getSecondaryTextColor(),
                                  size: 18,
                                )
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).push(PageRouteBuilder(pageBuilder: (a, b, c) => CreateSchedulePage()));
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ThemeController.getSecondaryBackgroundColor(),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 3,
                              color: Color(0x33000000),
                              offset: Offset(0, 1),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.barcode_viewfinder,
                                      color: ThemeController.getSecondaryTextColor(),
                                      size: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    Text('Groceries Search', style: ThemeController.getLabelLargeFont())
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: ThemeController.getSecondaryTextColor(),
                                  size: 18,
                                )
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GroceriesSearchPage()));
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ThemeController.getSecondaryBackgroundColor(),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 3,
                              color: Color(0x33000000),
                              offset: Offset(0, 1),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.table_badge_more,
                                      color: ThemeController.getSecondaryTextColor(),
                                      size: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    Text('View Schedule', style: ThemeController.getLabelLargeFont())
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: ThemeController.getSecondaryTextColor(),
                                  size: 18,
                                )
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewSchedulePage()));
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ThemeController.getSecondaryBackgroundColor(),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 3,
                              color: Color(0x33000000),
                              offset: Offset(0, 1),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.command,
                                      color: ThemeController.getSecondaryTextColor(),
                                      size: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    Text('Schedule Generator', style: ThemeController.getLabelLargeFont())
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: ThemeController.getSecondaryTextColor(),
                                  size: 18,
                                )
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ScheduleGeneratePage()));
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ThemeController.getSecondaryBackgroundColor(),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 3,
                              color: Color(0x33000000),
                              offset: Offset(0, 1),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.insights_outlined,
                                      color: ThemeController.getSecondaryTextColor(),
                                      size: 25,
                                    ),
                                    const SizedBox(width: 10),
                                    Text('Insights', style: ThemeController.getLabelLargeFont())
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: ThemeController.getSecondaryTextColor(),
                                  size: 18,
                                )
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InsightsPage()));
                            },
                          ),
                        ),
                      ),
                    ]
                        .divide(const SizedBox(height: 14))
                        .around(const SizedBox(height: 15)),
                  ),
                  Opacity(
                    opacity: 0.6,
                    child: Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                        child: Text(
                          'App Settings',
                          style: ThemeController.getBodyMediumFont(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                  decoration: BoxDecoration(
                    color: ThemeController.getSecondaryBackgroundColor(),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 3,
                        color: Color(0x33000000),
                        offset: Offset(0, 1),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                    child: TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: ThemeController.getSecondaryTextColor(),
                                size: 25,
                              ),
                              const SizedBox(width: 10),
                              Text('Support', style: ThemeController.getLabelLargeFont())
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: ThemeController.getSecondaryTextColor(),
                            size: 18,
                          )
                        ],
                      ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SupportPage()));
                        },
                    ),
                  ),
                ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeController.getSecondaryBackgroundColor(),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 3,
                          color: Color(0x33000000),
                          offset: Offset(0, 1),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                      child: TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.settings,
                                  color: ThemeController.getSecondaryTextColor(),
                                  size: 25,
                                ),
                                const SizedBox(width: 10),
                                Text('Application Settings', style: ThemeController.getLabelLargeFont())
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: ThemeController.getSecondaryTextColor(),
                              size: 18,
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage(parentState: this)));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeController.getSecondaryBackgroundColor(),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 3,
                          color: Color(0x33000000),
                          offset: Offset(0, 1),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                      child: TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.notifications,
                                  color: ThemeController.getSecondaryTextColor(),
                                  size: 25,
                                ),
                                const SizedBox(width: 10),
                                Text('Notifications Center', style: ThemeController.getLabelLargeFont())
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: ThemeController.getSecondaryTextColor(),
                              size: 18,
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationsPage()));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(25),
          child: AppBar(
            backgroundColor: ThemeController.getPrimaryBackgroundColor(),
            automaticallyImplyLeading: false,
            leading: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                scaffoldKey.currentState!.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: ThemeController.getSecondaryTextColor(),
                size: 24,
              ),
            ),
            title: Align(
              alignment: const AlignmentDirectional(0, -1),
              child: Text(
                'MeFit',
                style: ThemeController.getHeadlineMediumFont().override(
                  fontFamily: 'Outfit',
                  color: ThemeController.getPrimaryTextColor(),
                  fontSize: 22,
                ),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                child: Align(
                  alignment: const AlignmentDirectional(0, -1),
                  child: Container(
                    width: 80,
                    height: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image(
                      image: Main.profilePhoto.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              )
            ],
            centerTitle: false,
            elevation: 0,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InsightsPage()));
                  },
                  child:Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ThemeController.getSecondaryBackgroundColor(),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x25090F13),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting!',
                          style: ThemeController.getHeadlineMediumFont(),
                        ),
                        Divider(
                          height: 24,
                          thickness: 2,
                          color: ThemeController.getPrimaryBackgroundColor(),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: Main.dailyStepsGoal > 0,
                              child: Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Daily Step Goal',
                                      style: ThemeController.getBodyMediumFont(),
                                    ),
                                    CircularPercentIndicator(
                                      percent: (Main.todaySteps / Main.dailyStepsGoal) > 1 ? 1 : (Main.todaySteps / Main.dailyStepsGoal),
                                      radius: 60,
                                      lineWidth: 12,
                                      animation: true,
                                      animateFromLastPercent: true,
                                      progressColor: const Color(0xFFC95B05),
                                      backgroundColor: ThemeController.getAccent4Color(),
                                      center: Text(
                                        '${(((Main.todaySteps / Main.dailyStepsGoal) > 1 ? 1 : (Main.todaySteps / Main.dailyStepsGoal)) * 100.0).toDouble().toStringAsFixed(2)}%',
                                        style: ThemeController.getHeadlineSmallFont(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Daily Steps',
                                    style: ThemeController.getBodyMediumFont(),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${Main.todaySteps}',
                                        style: ThemeController.getDisplaySmallFont().override(
                                          fontFamily: 'Outfit',
                                          fontSize: 26,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Align(
                                        alignment:
                                        const AlignmentDirectional(0, 0),
                                        child: SvgPicture.asset(
                                          'assets/images/steps.svg',
                                          width: 32,
                                          height: 32,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(4, 12, 4, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeController.getSecondaryBackgroundColor(),
                    borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                    child: HomepageCalendarWidget(),
                  ),
                ),
              ),
              Visibility(
                visible: dayTitle.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 44),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ThemeController.getSecondaryBackgroundColor(),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 7,
                                color: Color(0x2F1D2429),
                                offset: Offset(0, 3),
                              )
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return TodaySchedulePage(dayIndex: Main.currentWorkoutScheduleDay - 1);
                              }));
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ThemeController.getSecondaryBackgroundColor(),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: ThemeController.getAlternateColor(),
                                  width: 1,
                                ),
                              ),
                              child: Main.isThereWorkout() ? Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                                      child: Text(
                                        'Upcoming Activity',
                                        style: ThemeController.getTitleLargeFont(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 0, 0),
                                      child: Text(
                                        'Tasks Overview',
                                        style: ThemeController.getLabelMediumFont(),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 32,
                                            constraints: const BoxConstraints(maxHeight: 32),
                                            decoration: BoxDecoration(
                                              color: ThemeController.getSecondaryBackgroundColor(),
                                              borderRadius:
                                              BorderRadius.circular(30),
                                            ),
                                            child: Row(
                                              mainAxisSize:
                                              MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            8),
                                                        child: Icon(Icons.timelapse, color: ThemeController.getPrimaryTextColor(),),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                                        child: Text(
                                                          'Day ${Main.currentWorkoutScheduleDay}',
                                                          style: ThemeController.getBodyMediumFont(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 32,
                                            constraints: const BoxConstraints(maxHeight: 32),
                                            decoration: BoxDecoration(
                                              color: ThemeController.getSecondaryBackgroundColor(),
                                              borderRadius:
                                              BorderRadius.circular(30),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                      const AlignmentDirectional(-0.8, 0),
                                      child: Text(
                                        dayTitle,
                                        style: ThemeController.getTitleMediumFont(),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: ThemeController.getSecondaryBackgroundColor(),
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            border: Border.all(
                                              color: ThemeController.getAlternateColor(),
                                              width: 1,
                                            ),
                                          ),
                                          alignment: const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.asset(
                                                'workout_days/${Random().nextInt(13) + 1}.jpg',
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 12),
                                child: Padding(
                                  padding:
                                  const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                                  child: Text(
                                    'Good Job!\nNo more workouts today!',
                                    style: ThemeController.getTitleLargeFont(),
                                  ),
                                ),
                              ),
                            ).animateOnPageLoad(animationsMap[
                            'containerOnPageLoadAnimation']!),
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
    );
  }

  void updatePage() {
    setState(() {});
  }
}
