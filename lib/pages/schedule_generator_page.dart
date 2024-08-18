import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:me_fit/pages/schedule_preview_page.dart';
import 'package:me_fit/utilities/schedule_generator.dart';

import '../controllers/theme_controller.dart';
import '../main.dart';
import 'models/schedule_generator_model.dart';
export 'models/schedule_generator_model.dart';

class ScheduleGeneratePage extends StatefulWidget {
  const ScheduleGeneratePage({super.key});

  @override
  State<ScheduleGeneratePage> createState() => ScheduleGenerateState();

  static String calculateWeightClass(double height, double weight) {
    final bmi = weight / (height / 100 * height / 100);

    const skinnyBmi = 18.5;
    const underweightBmi = 25;
    const averageBmi = 30;
    const overweightBmi = 35;

    if (bmi < skinnyBmi) {
      return 'Skinny';
    } else if (bmi < underweightBmi) {
      return 'Underweight';
    } else if (bmi < averageBmi) {
      return 'Average';
    } else if (bmi < overweightBmi) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  static double calculateWeightToLose(double targetWeight, double weight){
    double weightToLose = weight - targetWeight;
    return(weightToLose.abs());
  }

  static double calculateTimeNeeded(double weightToLose){
    double reasonableTime = (weightToLose / 0.7) / 4;
    return(reasonableTime);
  }

  static String stepsFeedback(int dailySteps) {

    if (dailySteps < 3000) {
      return 'is a very low daily steps count and considered as having a sedentary lifestyle, if you are physically able, try to walk more.';
    } else if ( 3000 <= dailySteps && dailySteps < 5000) {
      return 'is considered a low daily steps count, walking more would help you be more active and improve your general health.';
    } else if ( 5000 <= dailySteps && dailySteps < 7000 ) {
      return 'is the average and a good goal if you do not walk much.';
    } else if ( 7000 <= dailySteps && dailySteps < 10000 ) {
      return 'is above average and a very good goal, Good job.';
    } else if ( 10000 <= dailySteps && dailySteps < 20000) {
      return 'is excellent, and you are considered a very active person, Impressive!.';
    } else if ( dailySteps >= 20000) {
      return 'is a very high daily average , this may exhaust and over drain you';
    }
    else{
      return "";
    }

  }


}

class ScheduleGenerateState extends State<ScheduleGeneratePage> {
  late ScheduleGenerateModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  double weight = Main.weight!.toDouble();
  double height = Main.height!.toDouble();
  double targetWeight = 0;
  double reasonableTime = 0;
  String gainOrLose = "";
  double weightToLose = 0;
  int targetDailySteps = 0;
  String stepsMessage = "";

  // Schedule parameters:
  String weightClass = "";
  String pastExercisingRegularity = "Never";
  String exercisingGoal = "Weight Loss";
  int dailyExerciseDuration = 30;
  int weeklyExercisingDays = 2;
  bool isGymAvailable = true;

  String errorMessage = "Enter your weight and height";

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ScheduleGenerateModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    weightClass = ScheduleGeneratePage.calculateWeightClass(height, weight);
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

    void calculateTarget() {
      setState(() {
        if(targetWeight> weight){
          gainOrLose = "gain";
        }
        else{
          gainOrLose = "lose";
        }
        weightToLose = ScheduleGeneratePage.calculateWeightToLose(targetWeight, weight);
        reasonableTime = ScheduleGeneratePage.calculateTimeNeeded(weightToLose);
        errorMessage = "";
      });
    }

  void processSteps() {
    setState(() {
      stepsMessage = ScheduleGeneratePage.stepsFeedback(targetDailySteps);
      errorMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: ThemeController.getPrimaryBackgroundColor(),
        appBar: AppBar(
          backgroundColor: ThemeController.getSecondaryBackgroundColor(),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
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
          // actions: [],
          flexibleSpace: FlexibleSpaceBar(
            background: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/MeFit_Icon.png',
                fit: BoxFit.fitHeight,
                alignment: const Alignment(0, 1),
              ),
            ),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Generate your schedule!',
                    style:
                    FlutterFlowTheme.of(context).headlineLarge.override(
                      fontFamily: 'Outfit',
                      letterSpacing: 0,
                    ),
                  ),
                  Visibility(
                    visible: weight > 0 && height > 0,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
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
                          padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                          child: AutoSizeText(
                            'According to your body index you are considered "$weightClass"',
                            style: ThemeController.getBodyMediumFont()
                                .override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                            minFontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: TextFormField(
                      controller: _model.textController3,
                      focusNode: _model.textFieldFocusNode3,
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      obscureText: false,
                      onChanged: (newText) {
                        if (double.tryParse(newText) != null) {
                          targetWeight = double.parse(newText);
                          if(targetWeight > 0) {
                            calculateTarget();
                          }
                          else{
                            targetWeight = 0;
                            setState(() {
                              errorMessage = "Target is invalid!";
                            });
                          }
                        } else {
                          targetWeight = 0;
                          setState(() {
                            errorMessage = "Target weight is invalid!";
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Your target weight in kg',
                        hintText: 'Enter Your target weight in kg',
                        hintStyle: ThemeController.getBodyLargeFont().override(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFF34E3A),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: ThemeController.getBodyMediumFont().override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                      validator: _model.textController3Validator
                          .asValidator(context),
                    ),
                  ),
                  Visibility(
                    visible: weightToLose > 0 && reasonableTime > 0,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
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
                          padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                          child: AutoSizeText(
                            '${reasonableTime.toStringAsFixed(0)} months is a reasonable time to $gainOrLose ${weightToLose.toStringAsFixed(2)} Kilograms',
                            style: ThemeController.getBodyMediumFont()
                                .override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                            minFontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: TextFormField(
                      controller: _model.textController4,
                      focusNode: _model.textFieldFocusNode4,
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      obscureText: false,
                      onChanged: (newText) {
                        if (int.tryParse(newText) != null) {
                          targetDailySteps = int.parse(newText);
                          if(targetDailySteps > 0) {
                            processSteps();
                          }
                          else{
                            targetDailySteps = 0;
                            setState(() {
                              errorMessage = "Target daily steps is invalid!";
                            });
                          }
                        } else {
                          targetDailySteps = 0;
                          setState(() {
                            errorMessage = "Target daily steps is invalid!";
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Your target daily steps',
                        hintText: 'Enter your target daily steps',
                        hintStyle: ThemeController.getBodyLargeFont().override(
                          fontFamily: 'Readex Pro',
                          letterSpacing: 0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFF34E3A),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0x00000000),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: ThemeController.getBodyMediumFont().override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                      validator: _model.textController4Validator
                          .asValidator(context),
                    ),
                  ),
                  Visibility(
                    visible: targetDailySteps > 0,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
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
                          padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                          child: AutoSizeText(
                            'Walking ${targetDailySteps.toStringAsFixed(0)} steps daily $stepsMessage',
                            style: ThemeController.getBodyMediumFont()
                                .override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                            minFontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
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
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 10, 16, 0),
                              child: Text(
                                'In the past 6 months, how often did you exercise?',
                                style: ThemeController.getBodyLargeFont()
                                    .override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 16, 16, 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: pastExercisingRegularity == "Never" ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'Never',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      pastExercisingRegularity = 'Never';
                                    });
                                  },
                                ),
                                TextButton(
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: pastExercisingRegularity == "Rarely" ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'Rarely',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      pastExercisingRegularity = 'Rarely';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 16, 16, 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: pastExercisingRegularity == "Regularly" ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'Regularly',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      pastExercisingRegularity = 'Regularly';
                                    });
                                  },
                                ),
                                TextButton(
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: pastExercisingRegularity == "Always" ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'Always',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      pastExercisingRegularity = 'Always';
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
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
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 10, 16, 0),
                              child: Text(
                                'What is your goal from exercising?',
                                style: ThemeController.getBodyLargeFont()
                                    .override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 16, 16, 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: exercisingGoal == "Weight Loss" ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'Weight Loss',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      exercisingGoal = "Weight Loss";
                                    });
                                  },
                                ),
                                TextButton(
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: exercisingGoal == "General Fitness" ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'General Fitness',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      exercisingGoal = "General Fitness";
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 16, 16, 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: exercisingGoal == "Heart Health" ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'Heart Health',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      exercisingGoal = "Heart Health";
                                    });
                                  },
                                ),
                                TextButton(
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: exercisingGoal == "Strength" ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'Strength',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      exercisingGoal = "Strength";
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 16, 16, 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: exercisingGoal == "Hypertrophy" ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'Hypertrophy',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      exercisingGoal = "Hypertrophy";
                                    });
                                  },
                                ),
                                TextButton(
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: exercisingGoal == "HIIT" ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'HIIT',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      exercisingGoal = "HIIT";
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 16, 16, 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: exercisingGoal == "Power Lifting" ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'Power Lifting',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      exercisingGoal = "Power Lifting";
                                    });
                                  },
                                ),
                                TextButton(
                                  child: Container(
                                    width: 100,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: exercisingGoal == "Body Building" ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'Body Building',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      exercisingGoal = "Body Building";
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
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
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 10, 16, 0),
                              child: Text(
                                'How many minutes are you willing to exercise daily in?',
                                style: ThemeController.getBodyLargeFont()
                                    .override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 16, 16, 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                                  ),
                                  child: Container(
                                    width: 60,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: dailyExerciseDuration == 30 ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          '30 m',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      dailyExerciseDuration = 30;
                                    });
                                  },
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                                  ),
                                  child: Container(
                                    width: 60,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: dailyExerciseDuration == 60 ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          '60 m',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      dailyExerciseDuration = 60;
                                    });
                                  },
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                                  ),
                                  child: Container(
                                    width: 60,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: dailyExerciseDuration == 90 ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          '90 m',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      dailyExerciseDuration = 90;
                                    });
                                  },
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                                  ),
                                  child: Container(
                                    width: 60,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: dailyExerciseDuration == 120 ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          '120 m',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      dailyExerciseDuration = 120;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
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
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 10, 16, 0),
                              child: Text(
                                'Weekly, how many days are you planning to exercise?',
                                style: ThemeController.getBodyLargeFont()
                                    .override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 16, 16, 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Container(
                                    width: 75,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: weeklyExercisingDays == 2 ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          '2 days',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      weeklyExercisingDays = 2;
                                    });
                                  },
                                ),
                                TextButton(
                                  child: Container(
                                    width: 75,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: weeklyExercisingDays == 3 ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          '3 days',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      weeklyExercisingDays = 3;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 16, 16, 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Container(
                                    width: 75,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: weeklyExercisingDays == 4 ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          '4 days',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      weeklyExercisingDays = 4;
                                    });
                                  },
                                ),
                                TextButton(
                                  child: Container(
                                    width: 75,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: weeklyExercisingDays == 5 ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          '5 days',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      weeklyExercisingDays = 5;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 16, 16, 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Container(
                                    width: 75,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: weeklyExercisingDays == 6 ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          '6 days',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      weeklyExercisingDays = 6;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
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
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 10, 16, 0),
                              child: Text(
                                'Do you have a Gym membership?',
                                style: ThemeController.getBodyLargeFont()
                                    .override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16, 16, 16, 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Container(
                                    width: 80,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: isGymAvailable ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'Yes',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isGymAvailable = true;
                                    });
                                  },
                                ),
                                TextButton(
                                  child: Container(
                                    width: 80,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: !isGymAvailable ? const Color(0xFFF34E3A) : ThemeController.getPrimaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFFF34E3A),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 0),
                                        child: Text(
                                          'No',
                                          style: ThemeController.getBodyMediumFont()
                                              .override(
                                            fontFamily: 'Readex Pro',
                                            color: ThemeController.getPrimaryTextColor(),
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isGymAvailable = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: errorMessage.isNotEmpty,
                    child: Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: Text(
                        errorMessage,
                        style: ThemeController.getTitleSmallFont().override(fontFamily: "Readex Pro", color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (errorMessage.isEmpty) {
                            Main.dailyStepsGoal = targetDailySteps;
                            await Main.writeAllData();
                            int scheduleNum = await ScheduleGenerator(weightClass: weightClass, pastExerciseRegularity: pastExercisingRegularity,
                            exercisingGoal: exercisingGoal, dailyExercisingDuration: dailyExerciseDuration,
                            weeklyExercisingDays: weeklyExercisingDays, isGymAvailable: isGymAvailable,
                            age: DateTime.now().difference(Main.dateOfBirth ?? DateTime.now()).inDays ~/ 365,
                                sex: (Main.isMale ?? true) ? 'M' : 'F').generateScheduleNumber();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SchedulePreviewPage(scheduleNum: scheduleNum)));
                          }
                        },
                        text: 'Generate Schedule',
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
