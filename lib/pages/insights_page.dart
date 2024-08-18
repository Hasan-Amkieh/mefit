import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:me_fit/controllers/theme_controller.dart';

import '../main.dart';
import '../utilities/widgets/line_chart_widget.dart';
import 'models/insights_model.dart';
export 'models/insights_model.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => InsightsPageState();
}

class InsightsPageState extends State<InsightsPage>
    with TickerProviderStateMixin {
  late InsightsModel _model;

  // final scaffoldKey = GlobalKey<ScaffoldState>();

  String stepsTimeClass = "D";
  String burnedCalsTimeClass = "D";

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InsightsModel());

    // For test purposes:
    // Main.burnedCalsCountTimeline.add(100);
    // Main.burnedCalsDateTimeline.add(DateTime.now().subtract(Duration(days: 4)).millisecondsSinceEpoch);
    //
    // Main.burnedCalsCountTimeline.add(1000);
    // Main.burnedCalsDateTimeline.add(DateTime.now().subtract(Duration(days: 3)).millisecondsSinceEpoch);
    //
    // Main.burnedCalsCountTimeline.add(10000);
    // Main.burnedCalsDateTimeline.add(DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch);

    updateStepsLineData();
    updateBurnedCalsLineData();
  }

  List<int> stepsData = [];
  List<DateTime> stepsDates = [];

  List<int> burnedCalsData = [];
  List<DateTime> burnedCalsDates = [];

  static List<List<int>> findIndicesBetweenTimeSeparators(List<DateTime> separators, List<DateTime> dataPoints) {
    List<List<int>> indices = [];

    for (int i = 0; i < separators.length - 1; i++) {
      DateTime startTime = separators[i];
      DateTime endTime = separators[i + 1];

      int startIndex = -1;
      int endIndex = -1;

      // Find start index
      for (int j = 0; j < dataPoints.length; j++) {
        if (dataPoints[j].isAfter(startTime) || dataPoints[j] == startTime) {
          startIndex = j;
          break;
        }
      }
      if (startIndex == -1) {
        return [[]];
      }

      // Find end index
      for (int j = startIndex; j < dataPoints.length; j++) {
        if (dataPoints[j].isAfter(endTime)) {
          endIndex = j - 1;
          break;
        } else if (dataPoints[j] == endTime) {
          endIndex = j;
          break;
        } else if (j == dataPoints.length - 1) {
          endIndex = j;
        }
      }

      if (startIndex != -1 && endIndex != -1) {
        indices.add([startIndex, endIndex]);
      }
    }

    return indices;
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
    Main.stepsDateTimeline.forEach((element) {
      stepsDates_.add(DateTime.fromMillisecondsSinceEpoch(element));
    });
    var regions = findIndicesBetweenTimeSeparators(timeSeparators, stepsDates_);
    stepsData = List.filled(timeSeparators.length - 1, 0);
    stepsDates = timeSeparators.sublist(0, timeSeparators.length - 1);

    for (int i = 0 ; i < timeSeparators.length - 1 ; i++) { // loop for x axis of the graph
      for (int j = 0 ; j < regions.length ; j++) {
        if (timeSeparators[i].millisecondsSinceEpoch <= stepsDates_[regions[j][0]].millisecondsSinceEpoch &&
            timeSeparators[i+1].millisecondsSinceEpoch > stepsDates_[regions[j][1]].millisecondsSinceEpoch) {
          if (regions[j][0] == regions[j][1]) {
            stepsData[i] = Main.stepsCountTimeline[regions[j][0]];
          } else {
            stepsData[i] = Main.countSteps(Main.stepsCountTimeline, regions[j][0], regions[j][1]);
          }
          regions.removeAt(j);
          break;
        }
      }
    }
  }

  void updateBurnedCalsLineData() {
    var now = DateTime.now();
    var base = DateTime(now.year, now.month, now.day);
    List<DateTime> timeSeparators = [];
    for (int i = 5 ; i > 0 ; i--) {
      if (burnedCalsTimeClass == "D") {
        timeSeparators.add(base.subtract(Duration(days: i)));
      } else if (burnedCalsTimeClass == "W") {
        timeSeparators.add(base.subtract(Duration(days: i * 7)));
      } else {
        timeSeparators.add(base.subtract(Duration(days: i * 30)));
      }
    }
    timeSeparators.add(DateTime.now());
    List<DateTime> burnedCalsDates_ = [];
    Main.burnedCalsDateTimeline.forEach((element) {
      burnedCalsDates_.add(DateTime.fromMillisecondsSinceEpoch(element));
    });
    var regions = findIndicesBetweenTimeSeparators(timeSeparators, burnedCalsDates_);
    burnedCalsData = List.filled(timeSeparators.length - 1, 0);
    burnedCalsDates = timeSeparators.sublist(0, timeSeparators.length - 1);

    for (int i = 0 ; i < timeSeparators.length - 1 ; i++) { // loop for x axis of the graph
      for (int j = 0 ; j < regions.length ; j++) {
        if (regions[j].isNotEmpty && timeSeparators[i].millisecondsSinceEpoch <= burnedCalsDates_[regions[j][0]].millisecondsSinceEpoch &&
            timeSeparators[i+1].millisecondsSinceEpoch > burnedCalsDates_[regions[j][1]].millisecondsSinceEpoch) {
          if (regions[j][0] == regions[j][1]) {
            burnedCalsData[i] = Main.burnedCalsCountTimeline[regions[j][0]];
          } else {
            burnedCalsData[i] = Main.countCals(Main.burnedCalsCountTimeline, regions[j][0], regions[j][1]);
          }
          regions.removeAt(j);
          break;
        }
      }
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
          title: Text(
            'Insights',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Outfit',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 25,
              letterSpacing: 0,
            ),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
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
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/bonfire.png',
                                  width: 88,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                                  child: Text(
                                    'You have a streak of',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                      fontFamily: 'Montserrat',
                                      letterSpacing: 0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                                  child: Text(
                                    '${Main.streakSeq.length} days',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                      fontFamily: 'Montserrat',
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold
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
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ThemeController.getSecondaryBackgroundColor(),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: ThemeController.getSecondaryBackgroundColor(),
                                    offset: const Offset(0, 2,),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'You have done',
                                            style: FlutterFlowTheme.of(
                                                context)
                                                .headlineSmall
                                                .override(
                                              fontFamily: 'Outfit',
                                              color: FlutterFlowTheme.of(
                                                  context)
                                                  .primaryText,
                                              fontSize: 24,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 0, 0),
                                            child: Text(
                                              '${Main.completedExercises.isNotEmpty ? ((Main.countCompletedExercises() / Main.completedExercises.length) * 100).toStringAsFixed(2) : 0}% of your exercises',
                                              style:
                                              FlutterFlowTheme.of(context)
                                                  .titleLarge
                                                  .override(
                                                fontFamily: 'Outfit',
                                                color: FlutterFlowTheme
                                                    .of(context)
                                                    .secondaryText,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          Icons.trending_up_sharp,
                                          color: Color(0xFFF8BD0A),
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ThemeController.getPrimaryBackgroundColor(),
                        borderRadius: const BorderRadius.only(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 12),
                              child: Text(
                                'Summary of taken steps',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
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
                            ),
                            LineChartWidget(yLabel: 'Steps', data: stepsData, dates: stepsDates),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 0),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1, -1),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 0, 12),
                              child: Text(
                                'Summary of your burned calories:',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 250,
                              child: FastSegmentedControl<String>(
                                name: 'segmented_control',
                                onChanged: (text) {
                                  setState(() {
                                    burnedCalsTimeClass = text!;
                                    updateBurnedCalsLineData();
                                  });
                                },
                                initialValue: burnedCalsTimeClass,
                                children: {
                                  "D" : Text('Daily', style: TextStyle(color: ThemeController.getPrimaryTextColor())),
                                  "W" : Text('Weekly', style: TextStyle(color: ThemeController.getPrimaryTextColor())),
                                  "M" : Text('Monthly', style: TextStyle(color: ThemeController.getPrimaryTextColor())),
                                },
                              ),
                            ),
                          ),
                          LineChartWidget(yLabel: 'Calories', data: burnedCalsData, dates: burnedCalsDates),
                        ],
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
