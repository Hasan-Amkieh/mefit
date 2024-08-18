import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:me_fit/utilities/streak_finder.dart';

import '../../controllers/theme_controller.dart';

class HomepageCalendarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomepageCalendarWidgetState();
  }
}

class HomepageCalendarWidgetState extends State<HomepageCalendarWidget> {
  static CalendarWeekController calendarController = CalendarWeekController();
  static List<Widget> streakWidgets = [];
  static late HomepageCalendarWidgetState currState;

  @override
  void initState() {
    super.initState();
    currState = this;
    calendarController = CalendarWeekController();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        updateStreaks();
      });
    });
  }

  static void updateStreaks() {
    streakWidgets = [];
    int i = 0;
    calendarController.rangeWeekDate.forEach((date) {
      if (i > 7) {
        return ;
      }
      streakWidgets.add(
        Opacity(
          opacity: DateTime.now().isBefore(date!) ? 0.0 : 1.0,
          child: Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 3),
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              'assets/images/${StreakFinder.isStreakAtDate(date) ? "bonfire" : "melting"}.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
      i++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Column(
        children: [
          CalendarWeek(
            controller: calendarController,
            height: 120,
            dateStyle: TextStyle(
                color: ThemeController.getPrimaryTextColor(),
                fontWeight: FontWeight.w400
            ),
            dayOfWeekStyle: TextStyle(
                color: ThemeController.getPrimaryTextColor(),
                fontWeight: FontWeight.w400
            ),
            weekendsStyle: TextStyle(
                color: ThemeController.getPrimaryTextColor(),
                fontWeight: FontWeight.w400
            ),
            showMonth: true,
            backgroundColor: ThemeController.getSecondaryBackgroundColor(),
            onWeekChanged: () {
              setState(() {
                updateStreaks();
              });
            },
            monthViewBuilder: (DateTime time) => Align(
              alignment: FractionalOffset.center,
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMM().format(time),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ThemeController.getPrimaryTextColor(),
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    ),
                  )),
            ),
            decorations: [
              DecorationItem(
                decorationAlignment: FractionalOffset.bottomRight,
                date: DateTime.now(),
                decoration: const Icon(
                  Icons.today,
                  color: Color(0xFFC95B05),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 3, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: streakWidgets.divide(const SizedBox(width: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
