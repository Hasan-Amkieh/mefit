import 'dart:math';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:me_fit/controllers/achievements_controller.dart';
import 'package:me_fit/controllers/theme_controller.dart';
import 'package:me_fit/main.dart';
import 'package:me_fit/pages/choose_workout_page.dart';
import 'package:me_fit/pages/home_page.dart';
import 'package:me_fit/utilities/workout_schedule.dart';

import 'models/create_schedule_model.dart';
export 'models/create_schedule_model.dart';

class CreateSchedulePage extends StatefulWidget {
  CreateSchedulePage({super.key});

  @override
  State<CreateSchedulePage> createState() => CreateScheduleState();
}

class CreateScheduleState extends State<CreateSchedulePage> {
  late CreateScheduleModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  WorkoutSchedule? workoutSchedule;

  TextEditingController dayNameController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController workoutNameController = TextEditingController();

  static String returnedWorkoutName = '';
  static String returnedWorkoutImageName = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateScheduleModel());
    returnedWorkoutName = '';
    returnedWorkoutImageName = '';

    workoutSchedule = WorkoutSchedule(workoutDays: [], description: "");
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void rebuild() {
    setState(() {});
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
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: const AlignmentDirectional(-1, -1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                    child: IconButton(
                      icon: Icon(
                        Icons.keyboard_backspace,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                Text(
                  'Weekly Schedule ',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'Mukta',
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView.builder(
                    itemCount: workoutSchedule!.workoutDays.length + 1,
                    itemBuilder: (context, index) {
                      if (workoutSchedule!.workoutDays.length == index) {
                        if (workoutSchedule!.workoutDays.length == 7) {
                          return Container();
                        }

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
                              child: TextButton.icon(
                                onPressed: () async {
                                  dayNameController.clear();
                                  repsController.clear();
                                  setsController.clear();
                                  workoutNameController.clear();

                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AddDayDiagram(parentState: this);
                                      }
                                  );
                                  setState(() {});
                                },
                                label: const Text("Add Day"),
                                icon: const Icon(Icons.add),
                              ),
                            ),
                          ),
                        );
                      }

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
                                    TextButton.icon(
                                      label: const Text("Add Workout"),
                                      icon: const Icon(Icons.add),
                                      onPressed: () async {
                                        dayNameController.clear();
                                        repsController.clear();
                                        setsController.clear();
                                        workoutNameController.clear();

                                        await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AddWorkoutDiagram(parentWidget: this, index: index);
                                            }
                                        );
                                        setState(() {});
                                      },
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
                          Navigator.of(context).pop();
                        },
                        text: 'Discard',
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
                          Main.scheduleDailyExercises = workoutSchedule!.workoutDays;
                          Main.workoutScheduleNumber = -2;
                          Main.firstDayDateOfWorkoutSchedule = DateTime.now();
                          Main.completedExercises = List.filled(workoutSchedule!.workoutDays[0].split(RegExp(Main.exercisesSeparationPattern)).length, false);
                          await Main.writeAllData();
                          if (Main.achievementsDates[28] == 0) {
                            AchievementsController.completeAchievement(28);
                          }
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
                        },
                        text: 'Save Schedule',
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

class AddDayDiagram extends StatefulWidget {
  AddDayDiagram({super.key, required this.parentState});
  CreateScheduleState parentState;

  @override
  State<StatefulWidget> createState() {
    return AddDayDiagramState();
  }

}

class AddDayDiagramState extends State<AddDayDiagram> {
  late TextEditingController dayNameController;
  late TextEditingController workoutNameController;
  late TextEditingController setsController;
  late TextEditingController repsController;

  @override
  void initState() {
    super.initState();

    dayNameController = TextEditingController();
    workoutNameController = TextEditingController();
    setsController = TextEditingController();
    repsController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Workout Day'),
      content: Flexible(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: dayNameController,
                textCapitalization: TextCapitalization.words,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Day name',
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
              ),
              CreateScheduleState.returnedWorkoutName.isEmpty ? TextFormField(
                controller: workoutNameController,
                textCapitalization: TextCapitalization.words,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Custom workout name',
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
              ) : Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Row(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset('workouts/${CreateScheduleState.returnedWorkoutImageName}', width: 100)),
                    const SizedBox(width: 12,),
                    SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(CreateScheduleState.returnedWorkoutName),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: setsController,
                textCapitalization: TextCapitalization.words,
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of sets',
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
              ),
              TextFormField(
                controller: repsController,
                textCapitalization: TextCapitalization.words,
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of reps',
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
              ),
              const SizedBox(height: 16),
              const Text('you can add one of our workouts:'),
              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(Icons.search),
                label: const Text('workout Search'),
                onPressed: () async {
                  await Navigator.of(context).push(PageRouteBuilder(pageBuilder: (a, b, c) => const ChooseWorkoutPage()));
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Discard'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.parentState.workoutSchedule?.workoutDays.add('${dayNameController.text}: ${CreateScheduleState.returnedWorkoutName.isNotEmpty ? CreateScheduleState.returnedWorkoutName : workoutNameController.text} (${setsController.text} sets, ${repsController.text} reps)');
            CreateScheduleState.returnedWorkoutName = '';
            CreateScheduleState.returnedWorkoutImageName = '';
            widget.parentState.rebuild();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class AddWorkoutDiagram extends StatefulWidget {
  AddWorkoutDiagram({super.key, required this.parentWidget, required this.index});
  CreateScheduleState parentWidget;
  int index;

  @override
  State<StatefulWidget> createState() {
    return AddWorkoutDiagramState();
  }
}

class AddWorkoutDiagramState extends State<AddWorkoutDiagram> {
  late TextEditingController workoutNameController;
  late TextEditingController setsController;
  late TextEditingController repsController;

  @override
  void initState() {
    super.initState();

    workoutNameController = TextEditingController();
    repsController = TextEditingController();
    setsController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Workout'),
      content: Flexible(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CreateScheduleState.returnedWorkoutName.isEmpty ? TextFormField(
                controller: workoutNameController,
                textCapitalization: TextCapitalization.words,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Custom workout name',
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
              ) : Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Row(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset('workouts/${CreateScheduleState.returnedWorkoutImageName}', width: 100)),
                    const SizedBox(width: 12,),
                    SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(CreateScheduleState.returnedWorkoutName),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: setsController,
                textCapitalization: TextCapitalization.words,
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of sets',
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
              ),
              TextFormField(
                controller: repsController,
                textCapitalization: TextCapitalization.words,
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of reps',
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
              ),
              const SizedBox(height: 16),
              const Text('you can add one of our workouts:'),
              const SizedBox(height: 8),
              TextButton.icon(
                icon: const Icon(Icons.search),
                label: const Text('workout Search'),
                onPressed: () async {
                  await Navigator.of(context).push(PageRouteBuilder(pageBuilder: (a, b, c) => const ChooseWorkoutPage()));
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Discard'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.parentWidget.workoutSchedule?.workoutDays[widget.index] = widget.parentWidget.workoutSchedule!.workoutDays[widget.index] +
                (', ${CreateScheduleState.returnedWorkoutName.isNotEmpty ? CreateScheduleState.returnedWorkoutName : workoutNameController.text} (${setsController.text} sets, ${repsController.text} reps)');
            CreateScheduleState.returnedWorkoutName = '';
            CreateScheduleState.returnedWorkoutImageName = '';
            widget.parentWidget.rebuild();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

}
