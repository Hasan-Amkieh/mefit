import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:me_fit/controllers/achievements_controller.dart';
import 'package:me_fit/pages/home_page.dart';
import 'package:me_fit/utilities/streak_finder.dart';
import 'package:me_fit/utilities/workout_schedule.dart';
import '../utilities/exercise.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'exercise_page.dart';

import '../controllers/theme_controller.dart';
import '../main.dart';
import '../utilities/widgets/calendar_widget.dart';
import 'models/today_schedule_model.dart';
export 'models/today_schedule_model.dart';

class TodaySchedulePage extends StatefulWidget {
  TodaySchedulePage({super.key, required this.dayIndex});
  int dayIndex;

  @override
  State<TodaySchedulePage> createState() => _ScheduleCopyWidgetState();
}

class _ScheduleCopyWidgetState extends State<TodaySchedulePage> {
  late TodayScheduleModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> exercises = [];
  List<Exercise> allExercises = [];


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TodayScheduleModel());

    rootBundle.loadString('assets/data/exercises_description.csv').then((value) {
      setState(() {
        for (List<String> exercise in const CsvToListConverter().convert(value, shouldParseNumbers: false, textDelimiter: '"',  fieldDelimiter: ',', eol: '\n')) {
          allExercises.add(Exercise(name: exercise[0], instructions: exercise[1],
              purpose: exercise[2], bodyPart: exercise[3], equipment: exercise[4], imageName: exercise[5].trim() == '-' ? 'default.webp' : "${exercise[0].replaceAll(' ', '_')}.${exercise[5]}".trim()));
        }
      });

    });

    WorkoutSchedule workoutSchedule = WorkoutSchedule(workoutDays: Main.scheduleDailyExercises, description: "");
    print("Day index: ${widget.dayIndex}");
    int titleSepIndex = workoutSchedule.workoutDays[widget.dayIndex].indexOf(':');
    List<String>? temp = [workoutSchedule.workoutDays[widget.dayIndex].substring(0, titleSepIndex), workoutSchedule.workoutDays[widget.dayIndex].substring(titleSepIndex + 1)];
    exercises = temp[1].split(RegExp(Main.exercisesSeparationPattern));

    if (Main.completedExercises.isEmpty) {
      Main.completedExercises = List.filled(exercises.length, false);
    }

    var now = DateTime.now();
    var diff_ = Main.lastCompletedExercisesDate.difference(now).abs().inDays;
    if (diff_ >= 7) {
      Main.workoutStreakStartDate = now;
      Main.writeAllPrefs();
    }

    if (Main.completedExercises.isNotEmpty && Main.completedExercises.every((element) => element)) {
      var diff = DateTime.now().difference(Main.workoutStreakStartDate).inDays.abs();
      if (diff >= 30 && Main.achievementsDates[18] == 0) {
        AchievementsController.completeAchievement(18);
      }
      if (diff >= 90 && Main.achievementsDates[19] == 0) {
        AchievementsController.completeAchievement(19);
      }
      if (diff >= 180 && Main.achievementsDates[20] == 0) {
        AchievementsController.completeAchievement(20);
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> checkBoxCallback(int index) async {
    setState(() {
      HomePageState.currState.setState(() {
        Main.completedExercises[index] = !Main.completedExercises[index];
        if (Main.completedExercises[index] && Main.achievementsDates[17] == 0) {
          AchievementsController.completeAchievement(17);
        }
        StreakFinder.isEligibleToStreakTodayAndRegister();
        HomepageCalendarWidgetState.currState.setState(() {HomepageCalendarWidgetState.updateStreaks();});
      });
    });
    if (Main.completedExercises.isNotEmpty && Main.completedExercises.every((element) => element)) {
      Main.lastCompletedExercisesDate = DateTime.now();
    }
    await Main.writeAllData();
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
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              border: Border.all(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: const AlignmentDirectional(-1, -1),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                          Icons.keyboard_backspace,
                          size: 28,
                          color: FlutterFlowTheme.of(context).primaryText
                      ),

                    ),
                  ),
                ),
                Text(
                  'Todays\' Schedule ',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'Mukta',
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      int sep = exercises[index].indexOf(' (');
                      String exerciseName = "";
                      String desc = "";
                      if (sep != -1) {
                        exerciseName = exercises[index].substring(0, sep).trim();
                        desc = exercises[index].substring(sep).trim();
                      } else {
                        exerciseName = exercises[index].trim();
                      }
                      desc = desc.replaceAll('(', '');
                      desc = desc.replaceAll(')', '');

                      return Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 0),
                        child: Container(
                          width: double.infinity,
                          height: 120,
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
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        Main.exerciseImageGetter.getImagePath(exerciseName),
                                        width: 106,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment: const AlignmentDirectional(0, -1),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                                          child: SizedBox(
                                            width: 200,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        int index = allExercises.indexWhere((exercise) => exercise.name.toLowerCase() == exerciseName.toLowerCase());
                                                        if (index != -1) {
                                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExercisePage(exercise: allExercises[index])));
                                                        }
                                                      },
                                                      child: Text(
                                                      exerciseName,
                                                      style: FlutterFlowTheme.of(context)
                                                          .titleSmall
                                                          .override(
                                                          fontFamily: 'Readex Pro',
                                                          letterSpacing: 0,
                                                          color: ThemeController.getPrimaryTextColor()
                                                      ),
                                                    ),)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: const AlignmentDirectional(0, 0),
                                        child: Container(
                                          width: 185,
                                          // height: 71,
                                          decoration: const BoxDecoration(
                                            color: Color(0x0014181B),
                                          ),
                                          child: Align(
                                            alignment: const AlignmentDirectional(0, -1),
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                                              child: Text(
                                                desc,
                                                style: FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .override(
                                                  fontFamily: 'Readex Pro',
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Flexible(
                                    child: Align(
                                      alignment: const AlignmentDirectional(-1, 0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          await checkBoxCallback(index);
                                        },
                                        child:Checkbox(
                                            value: Main.completedExercises[index],
                                            onChanged: (newVal) async {
                                              await checkBoxCallback(index);
                                            },
                                          activeColor: Color(0xCFF37F3A)
                                          ),
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
