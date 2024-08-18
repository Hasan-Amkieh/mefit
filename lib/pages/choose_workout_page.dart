import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:me_fit/pages/create_schedule_page.dart';

import '../controllers/theme_controller.dart';
import '../utilities/exercise.dart';
import 'exercise_page.dart';
import 'models/choose_workout_page_model.dart';
export 'models/choose_workout_page_model.dart';

class ChooseWorkoutPage extends StatefulWidget {
  const ChooseWorkoutPage({super.key});

  @override
  State<ChooseWorkoutPage> createState() => ChooseWorkoutState();
}

class ChooseWorkoutState extends State<ChooseWorkoutPage> {
  late ChooseWorkoutPageModel model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Exercise> allExercises = [];
  List<Exercise> foundResults = [];

  @override
  void initState() {
    super.initState();
    model = createModel(context, () => ChooseWorkoutPageModel());

    rootBundle.loadString('assets/data/exercises_description.csv').then((value) {
      setState(() {
        for (List<String> exercise in const CsvToListConverter().convert(value, shouldParseNumbers: false, textDelimiter: '"',  fieldDelimiter: ',', eol: '\n')) {
          allExercises.add(Exercise(name: exercise[0], instructions: exercise[1],
              purpose: exercise[2], bodyPart: exercise[3], equipment: exercise[4], imageName: exercise[5].trim() == '-' ? 'default.webp' : "${exercise[0].replaceAll(' ', '_')}.${exercise[5]}".trim()));
        }
        foundResults.addAll(allExercises);
      });
    });

    model.textController ??= TextEditingController();
    model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: ThemeController.getPrimaryBackgroundColor(),
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
              CreateScheduleState.returnedWorkoutName = '';
              CreateScheduleState.returnedWorkoutImageName = '';
              Navigator.of(context).pop();
            },
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: ThemeController.getSecondaryBackgroundColor(),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                        child: TextFormField(
                          controller: model.textController,
                          focusNode: model.textFieldFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Exercise name',
                            labelStyle: ThemeController.getLabelMediumFont()
                                .override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                            hintStyle: ThemeController.getLabelMediumFont()
                                .override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ThemeController.getAlternateColor(),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ThemeController.getPrimaryColor(),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ThemeController.getErrorColor(),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ThemeController.getErrorColor(),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding:
                            const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 16),
                          ),
                          style: ThemeController.getBodyMediumFont().override(
                            fontFamily: 'Readex Pro',
                            letterSpacing: 0,
                          ),
                          minLines: null,
                          onChanged: (newText) {
                            setState(() {
                              foundResults = allExercises.where((e) {
                                return e.name.toLowerCase().contains(newText.toLowerCase());
                              }).cast<Exercise>().toList();
                            });
                          },
                          validator: model.textControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                    FlutterFlowIconButton(
                      borderColor: const Color.fromRGBO(0, 0, 0, 0),
                      borderRadius: 20,
                      borderWidth: 1,
                      buttonSize: 40,
                      fillColor: ThemeController.getSecondaryBackgroundColor(),
                      icon: Icon(
                        Icons.clear,
                        color: ThemeController.getPrimaryTextColor(),
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          model.textController.text = "";
                          foundResults.addAll(allExercises);
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Search results',
                      style: ThemeController.getBodyMediumFont().override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      '${foundResults.length}',
                      style: ThemeController.getBodyMediumFont().override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: foundResults.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                          child: Container(
                            width: 100,
                            height: 100,
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
                              padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'workouts/${foundResults[index].imageName}',
                                      width: 102,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(
                                              10, 12, 0, 0),
                                          child: Text(
                                            foundResults[index].name,
                                            softWrap: false,
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            style: ThemeController.getBodyMediumFont()
                                                .override(
                                              fontFamily: 'Readex Pro',
                                              letterSpacing: 0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(
                                              20, 12, 0, 0),
                                          child: Text(
                                            "${foundResults[index].bodyPart}\n${foundResults[index].equipment}",
                                            style: ThemeController.getBodySmallFont()
                                                .override(
                                              fontFamily: 'Readex Pro',
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
                          ),
                        ),
                        onTap: () {
                          CreateScheduleState.returnedWorkoutName = foundResults[index].name;
                          CreateScheduleState.returnedWorkoutImageName = foundResults[index].imageName;
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
