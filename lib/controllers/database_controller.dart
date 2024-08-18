import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:me_fit/controllers/achievements_controller.dart';
import 'package:me_fit/utilities/user_info.dart';

import '../main.dart';
import 'auth.dart';

class DatabaseController {

  static late FirebaseDatabase db;
  static late FirebaseStorage storage;
  static bool isInitialized = false;

  static void initialize() {
    if (!isInitialized) {
      isInitialized = true;
      db = FirebaseDatabase.instanceFor(databaseURL: 'https://mefit-d6877-default-rtdb.europe-west1.firebasedatabase.app', app: Main.firebaseApp);
      storage = FirebaseStorage.instance;
    }
  }

  static Future<Image> retreiveImageWidget(String email) async {
    String email_ = formatEmail(email);
    if (Main.profilePhotoName == email_) {
      return Main.profilePhoto;
    } else {
      var ref = await storage.ref().listAll();
      String fileType = '';
      ref.items.forEach((element) {
        if (element.name.startsWith(email_)) {
          fileType = element.name.split('.')[1];
          return ;
        }
      });
      if (fileType.isNotEmpty) {
        var data = await storage.ref().child('$email_.$fileType').getData();
        Main.profilePhotoName = formatEmail(Auth().currentUser!.email ?? '');
        return Image.memory(data!);
      } else {
        Main.profilePhotoName = 'default_profile';
        return Image.asset(
          'assets/images/default_profile.png',
          width: 100,
          height: 100,
          fit: BoxFit.fill,
        );
      }
    }
  }

  static void uploadProfileImage(String email, File file) {
    storage.ref().child('${formatEmail(email)}.${file.path.split('.').last}').putFile(file);
    if (Main.achievementsDates[31] == 0) {
      AchievementsController.completeAchievement(31);
    }
  }

  static Future<void> updateProfileImage(String email, File file) async {
    var ref = storage.ref().child('${formatEmail(email)}.${file.path.split('.').last}');
    try {
      await ref.delete();
    } catch (e) {
      if (e.toString().contains("HttpResult: 404")) {
        print("File does not exist!");
      } else {
        print(e.toString());
      }
    }
    await ref.putFile(file);
    if (Main.achievementsDates[31] == 0) {
      AchievementsController.completeAchievement(31);
    }
  }

  static String formatEmail(String email) {
    return email.contains('.') ? email.substring(0, email.lastIndexOf('.')) : email;
  }

  static Future<bool> isAccountRegisteredInDB(String email) async {
    bool val = false;
    bool isCompleted = false;
    // print('looking for ${'users/${formatEmail(email)}'}');
    db.ref().child('users/${formatEmail(email)}').onValue.listen((event) {
      val = event.snapshot.value != null;
      isCompleted = true;
    });
    while (!isCompleted) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return val;
  }

  static void registerUser(String email, String username, String firstName, String lastName, double height, double weight, DateTime dateOfBirth, bool isMale, String country) {
    !isInitialized ? initialize() : null;

    Map map = {
      'username' : username,
      'firstName' : firstName,
      'lastName' : lastName,
      'height' : height,
      'weight' : weight,
      'dateOfBirth' : dateOfBirth.millisecondsSinceEpoch,
      'isMale' : isMale,
      'country' : country,
    };
    var ref = db.ref().child('users/${formatEmail(email)}');
    for (MapEntry entry in map.entries) {
      ref.child('${entry.key}').set(entry.value);
    }
    Main.username = username;
    Main.firstName = firstName;
    Main.lastName = lastName;
    Main.height = height;
    Main.weight = weight;
    Main.dateOfBirth = dateOfBirth;
    Main.isMale = isMale;
    Main.country = country;

    Main.writeAllPrefs();

  }

  static Future<bool> doesUserNameExist(String username) async {
    List allEmails = ((await db.ref().child('users').get()).value as Map? ?? {}).keys.toList();
    for (int i = 0 ; i < allEmails.length ; i++) {
      String x = (await db.ref('users/${formatEmail(allEmails[i])}/username').get()).value as String? ?? '';
      if (x == username) {
        return true;
      }
    }
    return false;
  }

  static Future<void> updateUserInfo(String email, String username, String firstName, String lastName, double height, double weight, String country) async {
    !isInitialized ? initialize() : null;

    // users/$email/... (firstname, last name, ...)
    Map map = {
      'username' : username,
      'firstName' : firstName,
      'lastName' : lastName,
      'height' : height,
      'weight' : weight,
      'country' : country,
    };
    var ref = db.ref().child('users/${formatEmail(email)}');
    for (MapEntry entry in map.entries) {
      await ref.child('${entry.key}').set(entry.value);
    }
    Main.username = username;
    Main.firstName = firstName;
    Main.lastName = lastName;
    Main.height = height;
    Main.weight = weight;
    Main.country = country;
  }

  static void retrieveUserInfo(String email) async {
    !isInitialized ? initialize() : null;

    var ref = db.ref().child('users/${formatEmail(email)}');
    Main.username = (await ref.child('username').get()).value as String?;
    Main.firstName = (await ref.child('firstName').get()).value as String?;
    Main.lastName = (await ref.child('lastName').get()).value as String?;
    Main.height = (await ref.child('height').get()).value as num?;
    Main.weight = (await ref.child('weight').get()).value as num?;
    var x = (await ref.child('dateOfBirth').get()).value as int?;
    Main.dateOfBirth = x == null ? null : DateTime.fromMillisecondsSinceEpoch(x);
    Main.isMale = (await ref.child('isMale').get()).value as bool?;
    Main.country = (await ref.child('country').get()).value as String?;
  }

  static Future<Map> getUserInfo(String email) async {
    !isInitialized ? initialize() : null;
    return (await db.ref().child('users/${formatEmail(email)}').get()).value as Map;
  }

  static Future<List<List<String>>> searchByUsername(String username) async { // the inner list contains email, username, country in the same order
    !isInitialized ? initialize() : null;

    List<List<String>> foundUsers = [];
    var database = (await db.ref().child('users').get()).value as Map<dynamic, dynamic>;
    database.forEach((email, value) {
      if (value['username'].toString().toLowerCase().contains(username.toLowerCase())) {
        if (email != formatEmail(Auth().currentUser!.email ?? '')) { // check if it s not the current user:
          foundUsers.add([email, value['username'], value['country']]);
        }
      }
    });

    return foundUsers;
  }

  static Future<void> sendInvitations(List<String> emails) async {
    var ref = db.ref();
    for (String email in emails) {
      var ref_ = ref.child('users/${formatEmail(email)}/incomingFriends');
      Map<String, num> val = (await ref_.get()).value as Map<String, num>? ?? {};
      val.addAll({formatEmail(Auth().currentUser!.email ?? '') : DateTime.now().millisecondsSinceEpoch});
      await ref_.set(val);
    }
  }

  static Future<Map> getFriendsInvitations(String email) async {
    return (await db.ref().child('users/${formatEmail(email)}/incomingFriends').get()).value as Map? ?? {};
  }

  static Future<void> acceptInvitation(String inviteeEmail, String invitorEmail) async {
    deleteInvitation(inviteeEmail, invitorEmail);
    var ref_ = db.ref().child('users/${formatEmail(invitorEmail)}/acceptedFriends');
    Map val = (await ref_.get()).value as Map? ?? {};
    val.addAll({formatEmail(Auth().currentUser!.email ?? '') : DateTime.now().millisecondsSinceEpoch});
    await ref_.set(val);

    ref_ = db.ref().child('users/${formatEmail(invitorEmail)}/friends');
    List val_ = List.from((await ref_.get()).value as List? ?? []);
    val_.add(formatEmail(inviteeEmail));
    await ref_.set(val_);

    ref_ = db.ref().child('users/${formatEmail(inviteeEmail)}/friends');
    val_ = List.from((await ref_.get()).value as List? ?? []);
    val_.add(formatEmail(invitorEmail));
    await ref_.set(val_);

    if (Main.achievementsDates[29] == 0) {
      AchievementsController.completeAchievement(29);
    }

    if (Main.achievementsDates[30] == 0 && (await countFriends(inviteeEmail)) >= 10) {
      AchievementsController.completeAchievement(30);
    }
  }

  static Future<int> countFriends(String email) async {
    return ((await db.ref().child('users/${formatEmail(email)}/friends').get()).value as List? ?? []).length;
  }

  static Future<void> deleteInvitation(String inviteeEmail, String invitorEmail) async {
    var ref_ = db.ref().child('users/${formatEmail(inviteeEmail)}/incomingFriends');
    Map val = (await ref_.get()).value as Map? ?? {};
    val.remove(formatEmail(invitorEmail));
    await ref_.set(val);
  }

  static Future<List<Map>> getFriends(String email) async {
    List emails = (await db.ref().child('users/${formatEmail(email)}/friends').get()).value as List? ?? [];
    List<Map> usersInfo = [];
    for (int i = 0 ; i < emails.length ; i++) {
      usersInfo.add(Map.from((await db.ref().child('users/${formatEmail(emails[i])}').get()).value as Map? ?? {}));
      usersInfo.last.addAll({'email' : emails[i]});
    }

    return usersInfo;
  }

  static Future<void> writeAllFields(String email) async { // takes all the current info in Main and updates it onto the DB
    !isInitialized ? initialize() : null;

    Map map = {
      'workoutScheduleNumber' : Main.workoutScheduleNumber,
      'firstDayDateOfWorkoutSchedule' : Main.firstDayDateOfWorkoutSchedule.millisecondsSinceEpoch,
      'completedExercises' : Main.completedExercises,
      'dailyStepsGoal' : Main.dailyStepsGoal,
      'completionExercisesDate' : Main.completionExercisesDate.millisecondsSinceEpoch,
      'stepsCountTimeline' : Main.stepsCountTimeline,
      'stepsDateTimeline' : Main.stepsDateTimeline,
      'todaySteps' : Main.todaySteps,
      'streakStartDate' : Main.streakStartDate.millisecondsSinceEpoch,
      'streakSeq' : Main.streakSeq,
      'burnedCalsCountTimeline' : Main.burnedCalsCountTimeline,
      'burnedCalsDateTimeline' : Main.burnedCalsDateTimeline,
      'achievementsDates' : Main.achievementsDates,
      'upcomingScheduledReminder' : Main.upcomingScheduledReminder,
      'dailyStepsCompletedInRowCount' : Main.dailyStepsCompletedInRowCount,
      'dailyStepsCompletedInRowLastDate' : Main.dailyStepsCompletedInRowLastDate,
    };
    var ref = db.ref().child('users/${formatEmail(email)}');
    for (MapEntry entry in map.entries) {
      await ref.child(entry.key).set(entry.value);
    }

  }

  static Future<void> readAllFields(String email) async {
    !isInitialized ? initialize() : null;

    Map data = (await db.ref().child('users/${formatEmail(email)}').get()).value as Map? ?? {};
    Main.workoutScheduleNumber = data.containsKey('workoutScheduleNumber') ? data['workoutScheduleNumber'] : -1;
    Main.firstDayDateOfWorkoutSchedule = data.containsKey('firstDayDateOfWorkoutSchedule') ? DateTime.fromMillisecondsSinceEpoch(data['firstDayDateOfWorkoutSchedule']) : DateTime.now();
    Main.completedExercises = data.containsKey('completedExercises') ? List.from(data['completedExercises']) : [];
    Main.dailyStepsGoal = data.containsKey('dailyStepsGoal') ? data['dailyStepsGoal'] : 0;
    Main.completionExercisesDate = data.containsKey('completionExercisesDate') ? DateTime.fromMillisecondsSinceEpoch(data['completionExercisesDate']) : DateTime.now();
    Main.stepsCountTimeline = data.containsKey('stepsCountTimeline') ? List.from(data['stepsCountTimeline']) : [];
    Main.stepsDateTimeline = data.containsKey('stepsDateTimeline') ? List.from(data['stepsDateTimeline']) : [];
    Main.todaySteps = data.containsKey('todaySteps') ? data['todaySteps'] : 0;
    Main.streakStartDate = data.containsKey('streakStartDate') ? DateTime.fromMillisecondsSinceEpoch(data['streakStartDate']) : DateTime.now();
    Main.streakSeq = data.containsKey('streakSeq') ? data['streakSeq'] : '';
    Main.burnedCalsCountTimeline = data.containsKey('burnedCalsCountTimeline') ? List.from(data['burnedCalsCountTimeline']) : [];
    Main.burnedCalsDateTimeline = data.containsKey('burnedCalsDateTimeline') ? List.from(data['burnedCalsDateTimeline']) : [];
    Main.achievementsDates = data.containsKey('achievementsDates') ? List.from(data['achievementsDates']) : List.filled(33, 0);
    Main.upcomingScheduledReminder = data.containsKey('upcomingScheduledReminder') ? data['upcomingScheduledReminder'] : 0;
    Main.dailyStepsCompletedInRowCount = data.containsKey('dailyStepsCompletedInRowCount') ? data['dailyStepsCompletedInRowCount'] : 0;
    Main.dailyStepsCompletedInRowLastDate = data.containsKey('dailyStepsCompletedInRowLastDate') ? data['dailyStepsCompletedInRowLastDate'] : 0;

    if (Main.workoutScheduleNumber != -1) {
      var x = await Main.loadWorkoutSchedule(Main.workoutScheduleNumber);
      Main.scheduleDailyExercises = x!.workoutDays;
    }
  }

  static Future<UserInfo> getUserStatistics(String email) async {
    !isInitialized ? initialize() : null;

    Map data = (await db.ref().child('users/${formatEmail(email)}').get()).value as Map? ?? {};
    var workoutScheduleNumber = data.containsKey('workoutScheduleNumber') ? data['workoutScheduleNumber'] : -1;
    var firstDayDateOfWorkoutSchedule = data.containsKey('firstDayDateOfWorkoutSchedule') ? DateTime.fromMillisecondsSinceEpoch(data['firstDayDateOfWorkoutSchedule']) : DateTime.now();
    List<bool> completedExercises = data.containsKey('completedExercises') ? List.from(data['completedExercises']) : [];
    var dailyStepsGoal = data.containsKey('dailyStepsGoal') ? data['dailyStepsGoal'] : 0;
    var completionExercisesDate = data.containsKey('completionExercisesDate') ? DateTime.fromMillisecondsSinceEpoch(data['completionExercisesDate']) : DateTime.now();
    List<int> stepsCountTimeline = data.containsKey('stepsCountTimeline') ? List.from(data['stepsCountTimeline']) : [];
    List<int> stepsDateTimeline = data.containsKey('stepsDateTimeline') ? List.from(data['stepsDateTimeline']) : [];
    var todaySteps = data.containsKey('todaySteps') ? data['todaySteps'] : 0;
    var streakStartDate = data.containsKey('streakStartDate') ? DateTime.fromMillisecondsSinceEpoch(data['streakStartDate']) : DateTime.now();
    var streakSeq = data.containsKey('streakSeq') ? data['streakSeq'] : '';
    List<int> burnedCalsCountTimeline = data.containsKey('burnedCalsCountTimeline') ? List.from(data['burnedCalsCountTimeline']) : [];
    List<int> burnedCalsDateTimeline = data.containsKey('burnedCalsDateTimeline') ? List.from(data['burnedCalsDateTimeline']) : [];
    List<int> achievementsDates = data.containsKey('achievementsDates') ? List.from(data['achievementsDates']) : List.filled(33, 0);
    var upcomingScheduledReminder = data.containsKey('upcomingScheduledReminder') ? data['upcomingScheduledReminder'] : 0;
    var dailyStepsCompletedInRowCount = data.containsKey('dailyStepsCompletedInRowCount') ? data['dailyStepsCompletedInRowCount'] : 0;
    var dailyStepsCompletedInRowLastDate = data.containsKey('dailyStepsCompletedInRowLastDate') ? data['dailyStepsCompletedInRowLastDate'] : 0;

    return UserInfo(workoutScheduleNumber: workoutScheduleNumber, firstDayDateOfWorkoutSchedule: firstDayDateOfWorkoutSchedule, completedExercises: completedExercises, dailyStepsGoal: dailyStepsGoal, completionExercisesDate: completionExercisesDate, stepsCountTimeline: stepsCountTimeline, stepsDateTimeline: stepsDateTimeline, todaySteps: todaySteps, streakSeq: streakSeq, burnedCalsDateTimeline: burnedCalsDateTimeline, burnedCalsCountTimeline: burnedCalsCountTimeline, achievementsDates: achievementsDates, upcomingScheduledReminder: upcomingScheduledReminder, streakStartDate: streakStartDate, dailyStepsCompletedInRowLastDate: dailyStepsCompletedInRowLastDate, dailyStepsCompletedInRowCount: dailyStepsCompletedInRowCount);
  }

  static Future<void> unfriend(String email1, String email2) async {
    List email1Friends = List.from((await db.ref().child('users/${formatEmail(email1)}/friends').get()).value as List? ?? []);
    email1Friends.remove(formatEmail(email2));
    (await db.ref().child('users/${formatEmail(email1)}/friends').set(email1Friends));

    List email2Friends = List.from((await db.ref().child('users/${formatEmail(email2)}/friends').get()).value as List? ?? []);
    email2Friends.remove(formatEmail(email1));
    (await db.ref().child('users/${formatEmail(email2)}/friends').set(email2Friends));
  }

}
