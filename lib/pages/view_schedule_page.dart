import 'dart:math';

import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:me_fit/controllers/theme_controller.dart';
import 'package:me_fit/main.dart';
import 'package:me_fit/pages/home_page.dart';
import 'package:me_fit/utilities/workout_schedule.dart';

import 'models/schedule_preview_model.dart';
export 'models/schedule_preview_model.dart';

class ViewSchedulePage extends StatefulWidget {
  ViewSchedulePage({super.key});

  @override
  State<ViewSchedulePage> createState() => ViewScheduleState();
}

class ViewScheduleState extends State<ViewSchedulePage> {
  late SchedulePreviewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  WorkoutSchedule? workoutSchedule;
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SchedulePreviewModel());

    if (Main.workoutScheduleNumber == -1) {
      isEmpty = true;
    } else {
      Main.loadWorkoutSchedule(Main.workoutScheduleNumber).then((schedule) {
        setState(() {
          workoutSchedule = schedule;
        });
      });
    }
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
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
            'Weekly Schedule',
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
        body: SafeArea(
          top: true,
          child: isEmpty ? Center(
            child: Text(
              'No workout schedule found!\n\nGo to the Schedule Generator page to get your first schedule generated',
              textAlign: TextAlign.center,
              style: ThemeController.getBodyLargeFont(),
            ),
          ) : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView.builder(
                    itemCount: workoutSchedule?.workoutDays.length,
                    itemBuilder: (context, index) {
                      int titleSepIndex = workoutSchedule?.workoutDays[index].indexOf(':') ?? -1;
                      List<String>? temp = [workoutSchedule?.workoutDays[index].substring(0, titleSepIndex) ?? '', workoutSchedule?.workoutDays[index].substring(titleSepIndex + 1) ?? ''];
                      String? title = temp[0];
                      List<String> exercises = temp[1].split(RegExp(Main.exercisesSeparationPattern));
                      String dayDescription = "";
                      exercises.forEach((exercise) {
                        dayDescription += '$exercise\n';
                      });
                      dayDescription = dayDescription.substring(0, dayDescription.length - 1);

                      return Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ThemeController.getPrimaryBackgroundColor(),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 12, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 8, 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'workout_days/${Random().nextInt(13) + 1}.jpg',
                                      width: MediaQuery.of(context).size.width * 0.35,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0, 8, 0, 0),
                                      child: Text(
                                        'Day ${index + 1}',
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                            fontFamily: 'Readex Pro',
                                            letterSpacing: 0,
                                            color: ThemeController.getPrimaryTextColor()
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0, 8, 0, 0),
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                title,
                                                style: FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                    fontFamily: 'Readex Pro',
                                                    letterSpacing: 0,
                                                    color: ThemeController.getPrimaryTextColor()
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ),
                                    Align(
                                      alignment: const AlignmentDirectional(-1, 0),
                                      child: Container(
                                        padding: const EdgeInsetsDirectional.fromSTEB(8, 20, 0, 12),
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                dayDescription,
                                                style: FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                  fontFamily: 'Outfit',
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FFButtonWidget(
                        onPressed: () async {
                          Main.scheduleDailyExercises = [];
                          Main.currentWorkoutScheduleDay = 1;
                          Main.completedExercises = [];
                          Main.workoutScheduleNumber = -1;
                          Main.completionExercisesDate = DateTime.now();
                          HomePageState.dayTitle = '';
                          await Main.writeAllData();
                          HomePageState.currState.setState(() {
                            Navigator.of(context).pop();
                          });
                        },
                        text: 'Delete Schedule',
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
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          ;
                        },
                        text: 'Edit Schedule',
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
                      )
                    ],
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
