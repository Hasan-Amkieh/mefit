import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:me_fit/controllers/notification_controller.dart';
import 'package:me_fit/utilities/achievement.dart';

import '../main.dart';

class AchievementsController {

  static List<Achievement> achievements = [];
  static Future<void> loadAchievements() async {
    if (achievements.isEmpty) {
      var value = await rootBundle.loadString('assets/data/achievements.csv');
      int i = 0;
      for (List<String> achievement in const CsvToListConverter().convert(value, shouldParseNumbers: false, textDelimiter: '"',  fieldDelimiter: ',', eol: '\n')) {
        achievements.add(Achievement(index: i, description: achievement[0], badgeDescription: achievement[1],
            isCompleted: Main.achievementsDates[i] != 0, dateOfCompletion: DateTime.fromMillisecondsSinceEpoch(Main.achievementsDates[i])));
        i++;
      }
    }
  }

  static List<Achievement> get2RandomAchievementsFrom(List<int> achievementsDates) { // gets two randomly selected achievements, if no achieved ones then un-achieved will replace them
    loadAchievements();
    var rand = Random();
    int i1 = rand.nextInt(30), i2 = rand.nextInt(30);
    i1 = i2 == i1 ? (i1 + 1) : i1;
    bool is1Found = false;
    for (int i = 0 ; i < achievements.length ; i++) {
      if (achievementsDates[i] != 0) {
        if (!is1Found) {
          is1Found = true;
          i1 = i;
        } else {
          i2 = i;
          i2 = i1 == i2 ? (i1 + 1) : i2;
          i2 = i2 > 32 ? (i1 - 1) : i2;
          return [achievements[i1], achievements[i2]];
        }
      }
    }

    i2 = i1 == i2 ? (i1 + 1) : i2;
    i2 = i2 > 32 ? (i1 - 1) : i2;
    return [achievements[i1], achievements[i2]];
  }

  static void completeAchievement(int index) {
    achievements[index].isCompleted = true;
    achievements[index].dateOfCompletion = DateTime.now();
    Main.achievementsDates[index] = achievements[index].dateOfCompletion.millisecondsSinceEpoch;
    NotificationController.generateAchievementNotification(index);
    Main.writeAllData();

    checkNumberOfBadgesGoal();
  }

  static void checkDailyStepsGoalInRow() {
    if (Main.dailyStepsGoal <= Main.todaySteps &&
        (DateTime.fromMillisecondsSinceEpoch(Main.dailyStepsCompletedInRowLastDate).difference(DateTime.now()).inHours.abs() >= 24
        || Main.dailyStepsCompletedInRowLastDate == 0)) {
      Main.dailyStepsCompletedInRowLastDate = DateTime.now().millisecondsSinceEpoch;
      Main.dailyStepsCompletedInRowCount += 1;
    } else if (Main.dailyStepsGoal <= Main.todaySteps &&
    DateTime.fromMillisecondsSinceEpoch(Main.dailyStepsCompletedInRowLastDate).difference(DateTime.now()).inHours.abs() > 24) {
      Main.dailyStepsCompletedInRowCount = 1;
      Main.dailyStepsCompletedInRowLastDate = DateTime.now().millisecondsSinceEpoch;
    }

    if (Main.achievementsDates[0] == 0 && Main.dailyStepsCompletedInRowCount >= 30) {
      completeAchievement(0);
    }
    if (Main.achievementsDates[1] == 0 && Main.dailyStepsCompletedInRowCount >= 90) {
      completeAchievement(1);
    }
    if (Main.achievementsDates[2] == 0 && Main.dailyStepsCompletedInRowCount >= 180) {
      completeAchievement(2);
    }
  }

  static void checkNumberOfBadgesGoal() {
    int truesCount = Main.achievementsDates.where((element) => element > 0).length;
    double percent = (truesCount / Main.achievementsDates.length);
    if (Main.achievementsDates[25] == 0 && percent >= 0.25) {
      completeAchievement(25);
    }
    if (Main.achievementsDates[26] == 0 && percent >= 0.5) {
      completeAchievement(26);
    }
    if (Main.achievementsDates[27] == 0 && percent == ((Main.achievementsDates.length - 1) / Main.achievementsDates.length)) {
      completeAchievement(27);
    }
  }

  static void checkTotalStepsAchievements() { // achievements checks from 13 to 17
    int totalSteps = 0;
    for (int i = 0 ; i < Main.stepsCountTimeline.length ; i++) {
      totalSteps += Main.stepsCountTimeline[i];
    }

    if (Main.achievementsDates[12] == 0 && totalSteps >= 1000000) {
      completeAchievement(12);
    } if (Main.achievementsDates[13] == 0 && totalSteps >= 5000000) {
      completeAchievement(13);
    } if (Main.achievementsDates[14] == 0 && totalSteps >= 10000000) {
      completeAchievement(14);
    } if (Main.achievementsDates[15] == 0 && totalSteps >= 20000000) {
      completeAchievement(15);
    } if (Main.achievementsDates[16] == 0 && totalSteps >= 50000000) {
      completeAchievement(16);
    }
  }

}
