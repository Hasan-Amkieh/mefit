import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:me_fit/controllers/achievements_controller.dart';
import 'package:me_fit/pages/notifications_page.dart';
import 'package:me_fit/pages/schedule_generator_page.dart';

import '../main.dart';
import '../pages/home_page.dart';

class NotificationController {

  static void generateWelcomingNotification() {
    if (Main.isPushNotifications) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 1, // 1 is allocated for the welcome notification
            channelKey: 'basic_channel',
            actionType: ActionType.Default,
            title: 'Welcome',
            body: 'Welcome to MeFit, start by generating workout schedule',
          )
      );
    }
  }

  static void generateFriendInvitation(String username) {
    if (Main.isPushNotifications) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 4, // 4 is allocated for friends invitations
            channelKey: 'basic_channel',
            actionType: ActionType.Default,
            title: 'Friend Invitation',
            body: '$username wants to be your friend!',
          )
      );
    }
  }

  static void generateAchievementNotification(int index) {
    if (Main.isPushNotifications) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 3, // 3 is allocated for the achievements notification
            channelKey: 'basic_channel',
            actionType: ActionType.Default,
            title: 'Achievement Completed!',
            body: '${AchievementsController.achievements[index].badgeDescription}: ${AchievementsController.achievements[index].description}',
          )
      );
    }
  }

  static List<String> reminders = [];
  static Future<void> startReminders() async {
    if (reminders.isEmpty) {
      rootBundle.loadString('assets/data/reminder_quotes.txt').then((value) {
        for (String reminder in value.split('\n')) {
          reminders.add(reminder.trim());
        }
        appendReminder();
      });
    } else {
      appendReminder();
    }
  }

  static Future<void> appendReminder() async {
    if (Main.isPushNotifications && Main.upcomingScheduledReminder <= DateTime.now().millisecondsSinceEpoch) {
      var upcomingDate = DateTime.now().add(const Duration(hours: 24));
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 2, // Unique ID for the notification
          channelKey: 'basic_channel',
          title: 'Quotes',
          body: reminders[Random().nextInt(reminders.length)],
        ),
        schedule: NotificationCalendar.fromDate(date: upcomingDate),
      );
      Main.upcomingScheduledReminder = upcomingDate.millisecondsSinceEpoch;
      Main.writeAllData();
    }
  }

  @pragma("vm:entry-point")
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  @pragma("vm:entry-point")
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    if (receivedNotification.id == 2) { // reminders id
      startReminders();
    }
  }

  @pragma("vm:entry-point")
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if (receivedAction.id == 1) {
      Navigator.of(HomePageState.currState.context).push(MaterialPageRoute(builder: (context) => const ScheduleGeneratePage()));
    } else if (receivedAction.id == 4) {
      Navigator.of(HomePageState.currState.context).push(MaterialPageRoute(builder: (context) => const NotificationsPage()));
    }
  }
}