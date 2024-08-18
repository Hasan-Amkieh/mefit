import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:me_fit/utilities/achievement.dart';

class AchievementWidget extends StatefulWidget {

  AchievementWidget({super.key, required this.achievement});
  Achievement achievement;

  @override
  State<StatefulWidget> createState() {
    return AchievementWidgetState();
  }

}

class AchievementWidgetState extends State<AchievementWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.achievement.isCompleted ? 1.0 : 0.2,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: const [
              BoxShadow(
                blurRadius: 3,
                color: Color(0x411D2429),
                offset: Offset(
                  0.0,
                  1,
                ),
              )
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 1, 1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/achievements/${widget.achievement.index + 1}.jpg',
                      width: 70,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 4, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.achievement.description,
                          style: FlutterFlowTheme.of(context)
                              .titleLarge
                              .override(
                            fontFamily: 'Outfit',
                            fontSize: 16,
                            letterSpacing: 0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 4, 8, 0),
                          child: AutoSizeText(
                            widget.achievement.badgeDescription,
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                              fontFamily: 'Readex Pro',
                              fontSize: 10,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.achievement.isCompleted,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0, 0, 4, 8),
                    child: Text(
                      '${widget.achievement.dateOfCompletion.day}/${widget.achievement.dateOfCompletion.month}/${widget.achievement.dateOfCompletion.year}',
                      textAlign: TextAlign.end,
                      style: FlutterFlowTheme.of(context)
                          .bodySmall
                          .override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                    ),
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
