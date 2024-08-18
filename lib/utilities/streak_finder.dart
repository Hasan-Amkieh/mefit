import 'package:me_fit/controllers/achievements_controller.dart';

import '../main.dart';

class StreakFinder {

  static bool isStreakToday() {
    return isStreakAtDate(DateTime.now());
  }

  static void isEligibleToStreakTodayAndRegister() {
    if (Main.dailyStepsGoal > 0 && Main.todaySteps >= Main.dailyStepsGoal &&
        Main.completedExercises.every((element) => element)) {
      registerStreakForToday();
    }
  }

  static bool _isBefore(DateTime date1, DateTime date2) {
    return date1.isBefore(date2);
  }

  static bool _isAfter(DateTime date1, DateTime date2) {
    return date1.day != date2.day && date1.isAfter(date2);
  }

  static int getTodayOffset() { // returns the offset in days from Main.streakStartDate
    var now = DateTime.now();
    return (DateTime(Main.streakStartDate.year, Main.streakStartDate.month, Main.streakStartDate.day)
        .difference(DateTime(now.year, now.month, now.day)).inDays).abs();
  }

  static int totalStreakSeqOffset() { // returns the last registered streak offset
    int offset = 0;
    print('seq ${Main.streakSeq}');
    for (int i = 0 ; i < Main.streakSeq.length ; i++) {
      offset += int.parse(Main.streakSeq[i]);
    }
    return offset;
  }

  static void registerStreakForToday() {
    if ((getTodayOffset() - totalStreakSeqOffset()) >= 0 && !isStreakToday()) {
      Main.streakSeq += '${getTodayOffset() - totalStreakSeqOffset()}';
    }

    if (Main.achievementsDates[21] == 0 && Main.streakSeq.length >= 50) {
      AchievementsController.completeAchievement(21);
    }
    if (Main.achievementsDates[22] == 0 && Main.streakSeq.length >= 100) {
      AchievementsController.completeAchievement(22);
    }
    if (Main.achievementsDates[23] == 0 && Main.streakSeq.length >= 500) {
      AchievementsController.completeAchievement(23);
    }
    if (Main.achievementsDates[24] == 0 && Main.streakSeq.length >= 1000) {
      AchievementsController.completeAchievement(24);
    }
  }

  static bool isStreakAtDate(DateTime date) {
    var now = DateTime.now();
    if (_isBefore(now, date) || _isAfter(Main.streakStartDate, date)) {
      return false;
    } else { // Otherwise, check the streak:
      int offset = 0;
      for (int i = 0 ; i < Main.streakSeq.length ; i++) {
        offset += int.parse(Main.streakSeq[i]);
        // print('${Main.streakStartDate.add(Duration(days: offset)).day} == ${date.day}');
        if (Main.streakStartDate.add(Duration(days: offset)).day == date.day) {
          return true;
        }
      }
    }

    return false;
  }

}

