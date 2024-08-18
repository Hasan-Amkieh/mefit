import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:me_fit/controllers/achievements_controller.dart';
import 'package:me_fit/utilities/widgets/achievement_widget.dart';

import '../utilities/achievement.dart';
import 'models/achievements_model.dart';
export 'models/achievements_model.dart';

class AchievementsPage extends StatefulWidget {
  AchievementsPage({super.key, required this.achievementsDates});
  List<int> achievementsDates;

  @override
  State<AchievementsPage> createState() => AchievementsPageState();
}

class AchievementsPageState extends State<AchievementsPage> {
  late AchievementsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Achievement> achievements = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AchievementsModel());

    AchievementsController.loadAchievements();
    achievements = List.from(AchievementsController.achievements);
    for (int i = 0 ; i < achievements.length ; i++) {
      achievements[i].isCompleted = widget.achievementsDates[i] > 0;
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              Navigator.of(context).pop();
            },
            child: IconButton(
              icon: const Icon(Icons.chevron_left_sharp, size: 30),
              color: FlutterFlowTheme.of(context).primaryText,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          title: Text(
            'Achievements',
            style: FlutterFlowTheme.of(context).headlineLarge.override(
              fontFamily: 'Outfit',
              letterSpacing: 0,
            ),
          ),
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: achievements.length,
            itemBuilder: (BuildContext context, int index) {
              return AchievementWidget(achievement: achievements[index]);
            },
          ),
        ),
      ),
    );
  }
}
