import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:me_fit/controllers/theme_controller.dart';
import 'package:me_fit/utilities/exercise.dart';

import 'models/exercise_page_model.dart';
export 'models/exercise_page_model.dart';

class ExercisePage extends StatefulWidget {
  final Exercise exercise;

  const ExercisePage({super.key, required this.exercise});

  @override
  State<ExercisePage> createState() => ExercisePageState();
}

class ExercisePageState extends State<ExercisePage>
    with TickerProviderStateMixin {
  late Schedule2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'imageOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(0, 40),
          end: const Offset(0, 0),
        ),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(0.6, 0.6),
          end: const Offset(1, 1),
        ),
      ],
    ),
    'textOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(50, 0),
          end: const Offset(0, 0),
        ),
      ],
    ),
    'rowOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(50, 0),
          end: const Offset(0, 0),
        ),
      ],
    ),
    'textOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 100.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 600.ms,
          begin: const Offset(60, 0),
          end: const Offset(0, 0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Schedule2Model());
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
        backgroundColor: ThemeController.getSecondaryBackgroundColor(),
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
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'locationImage',
                          transitionOnUserGestures: true,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              "workouts/${widget.exercise.imageName}".trim(),
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ).animateOnPageLoad(
                            animationsMap['imageOnPageLoadAnimation']!),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                          child: Text(
                            widget.exercise.name,
                            style: ThemeController.getDisplaySmallFont()
                                .override(
                              fontFamily: 'Outfit',
                              letterSpacing: 0,
                            ),
                          ).animateOnPageLoad(
                              animationsMap['textOnPageLoadAnimation1']!),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Text(
                            "Targeted Body Part: ${widget.exercise.bodyPart}",
                            style: ThemeController.getBodyMediumFont()
                                .override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                          ).animateOnPageLoad(
                              animationsMap['rowOnPageLoadAnimation']!),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Text(
                            "Purpose of Exercise: ${widget.exercise.purpose}",
                            style: ThemeController.getBodyMediumFont()
                                .override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                          ).animateOnPageLoad(
                              animationsMap['rowOnPageLoadAnimation']!),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Text(
                            "Needed equipment: ${widget.exercise.equipment}",
                            style: ThemeController.getBodyMediumFont()
                                .override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                          ).animateOnPageLoad(
                              animationsMap['rowOnPageLoadAnimation']!),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(4, 16, 0, 0),
                          child: Text(
                            widget.exercise.instructions,
                            style: ThemeController.getBodyLargeFont()
                                .override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                          ).animateOnPageLoad(
                              animationsMap['textOnPageLoadAnimation2']!),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
