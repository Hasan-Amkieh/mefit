import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:csv/csv.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:me_fit/controllers/achievements_controller.dart';
import 'package:me_fit/controllers/database_controller.dart';
import 'package:me_fit/firebase_options.dart';
import 'package:me_fit/pages/fill_profile_info_page.dart';
import 'package:me_fit/pages/home_page.dart';
import 'package:me_fit/pages/login_page.dart';
import 'package:me_fit/utilities/exercise_image_getter.dart';
import 'package:me_fit/utilities/streak_finder.dart';
import 'package:me_fit/utilities/workout_schedule.dart';
import 'package:pedometer/pedometer.dart';

import 'controllers/auth.dart';
import 'controllers/notification_controller.dart';

class Main {

  static late Stream<StepCount> stepCountStream;
  static int overallSteps = 0;

  static int currentWorkoutScheduleDay = 1;

  static late Box savedData;

  // Notifications center:

  static List<List<String>> incomingInvitations = []; // holds email, username, full name
  static List<DateTime> incomingInvitationsTimes = []; // holds the time of invitations' when they got sent
  static List<Image> incomingInvitationsProfileImages = []; // holds the time of invitations' when they got sent

  // Notifications center;

  static List<String> scheduleDailyExercises = [];

  static ExerciseImageGetter exerciseImageGetter = ExerciseImageGetter();

  static String exercisesSeparationPattern = r',(?![^()]*\))(?![^{]*})';

  static Future<FirebaseApp> fApp = Firebase.initializeApp(name: 'MeFit', options: DefaultFirebaseOptions.android).then((value) async {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );
    firebaseApp = value;
    DatabaseController.initialize();
    String email = Auth().currentUser?.email ?? '';
    if (email.isNotEmpty) {
      isAccountRegistered = await DatabaseController.isAccountRegisteredInDB(email);
      await Main.initializeLocalDB();
      await Main.readAllData();
      await AchievementsController.loadAchievements();
      Main.countTodaySteps();
      if (Main.workoutScheduleNumber != -1 && Main.workoutScheduleNumber != -2) {
        var x = await Main.loadWorkoutSchedule(Main.workoutScheduleNumber);
        Main.scheduleDailyExercises = x!.workoutDays;
      }
    }
    return value;
  });
  static late FirebaseApp firebaseApp;
  static bool isAccountRegistered = false;

  static int daysBetweenWeekdays(DateTime date1, DateTime date2) {
    final int day1 = date1.weekday;
    final int day2 = date2.weekday;

    final int difference = (day2 - day1).abs() % 7;
    return difference < 0 ? difference + 7 : difference;
  }

  static Future<WorkoutSchedule?> loadWorkoutSchedule(int scheduleNumber) async {
    WorkoutSchedule? workoutSchedule;
    var value = await rootBundle.loadString('assets/data/schedules.csv');
    for (List<String> schedule in const CsvToListConverter().convert(value, shouldParseNumbers: false, textDelimiter: '"',  fieldDelimiter: ',', eol: '\n')) {
      if (schedule[0] == scheduleNumber.toString()) {
        workoutSchedule = WorkoutSchedule(workoutDays: schedule[1].trim().split('\n'), description: schedule[2]);
        print(workoutSchedule.workoutDays);
        print(workoutSchedule.description);
        break;
      }
    }
    return workoutSchedule;
  }

  static bool isThereWorkout() {
    return !completedExercises.every((element) => element) && completedExercises.isNotEmpty;
  }

  // prefs variables:

  static bool isDarkMode = true;
  static bool isPushNotifications = true;

  static int workoutScheduleNumber = -1;
  static DateTime firstDayDateOfWorkoutSchedule = DateTime.now();
  static List<bool> completedExercises = []; // today's exercises completion status
  static DateTime completionExercisesDate = DateTime.now();
  static DateTime lastCompletedExercisesDate = DateTime.now(); // stores the last date in which the workout schedule was completed
  static DateTime workoutStreakStartDate = DateTime.now();

  static int dailyStepsGoal = 0;
  static List<int> stepsCountTimeline = [];
  static List<int> stepsDateTimeline = [];
  static int todaySteps = 0;
  static DateTime streakStartDate = DateTime.now();
  static String streakSeq = '';

  static List<int> burnedCalsCountTimeline = [];
  static List<int> burnedCalsDateTimeline = [];

  static List<int> achievementsDates = List.filled(33, 0);

  static int upcomingScheduledReminder = 0; // to indicate if we have an upcoming reminder

  static DateTime lastCountDate20PercentDaysGoal = DateTime.now();
  static DateTime startDate20PercentDaysGoal = DateTime.now();

  static DateTime lastCountDate50PercentDaysGoal = DateTime.now();
  static DateTime startDate50PercentDaysGoal = DateTime.now();

  static DateTime lastCountDate100PercentDaysGoal = DateTime.now();
  static DateTime startDate100PercentDaysGoal = DateTime.now();

  // achievements specific:

  static int dailyStepsCompletedInRowCount = 0;
  static int dailyStepsCompletedInRowLastDate = 0;

  // achievements specific;

  // prefs variables;

  // DB variables:

  static String? username;
  static String? firstName;
  static String? lastName;
  static num? height;
  static num? weight;
  static DateTime? dateOfBirth;
  static bool? isMale;
  static String? country;

  static Image profilePhoto = Image.asset(
    'assets/images/default_profile.png',
    width: 100,
    height: 100,
    fit: BoxFit.fill,
  );
  static String profilePhotoName = 'default_profile';

  // DB variables;

  static void resetDataVariables() {
    workoutScheduleNumber = -1;
    firstDayDateOfWorkoutSchedule = DateTime.now();
    completionExercisesDate = DateTime.now();
    lastCompletedExercisesDate = DateTime.now();
    workoutStreakStartDate = DateTime.now();
    dailyStepsGoal = 0;
    stepsCountTimeline = [];
    stepsDateTimeline = [];
    completedExercises = [];

    todaySteps = 0;
    overallSteps = 0;
    scheduleDailyExercises = [];

    streakStartDate = DateTime.now();
    streakSeq = '';

    burnedCalsCountTimeline = [];
    burnedCalsDateTimeline = [];
  }

  static Future<void> readAllData() async {
    workoutScheduleNumber = savedData.get('workoutScheduleNumber') as int? ?? -1;
    completionExercisesDate = DateTime.fromMillisecondsSinceEpoch(savedData.get('completionExercisesDate') as int? ?? DateTime.now().millisecondsSinceEpoch);
    firstDayDateOfWorkoutSchedule = DateTime.fromMillisecondsSinceEpoch(savedData.get('firstDayDateOfWorkoutSchedule') as int? ?? DateTime.now().millisecondsSinceEpoch);
    dailyStepsGoal = savedData.get('dailyStepsGoal') as int? ?? 0;
    if (completionExercisesDate.day == DateTime.now().day) {
      Main.setCompletedExercisesString(savedData.get('completedExercises') as String? ?? '');
    } else {
      completionExercisesDate = DateTime.now();
      Main.completedExercises = [];
    }
    todaySteps = savedData.get('todaySteps') as int? ?? 0;
    streakStartDate = DateTime.fromMillisecondsSinceEpoch(savedData.get('streakStartDate') as int? ?? DateTime.now().millisecondsSinceEpoch);
    streakSeq = savedData.get('streakSeq') as String? ?? '';
    achievementsDates = processAchievementsDates(savedData.get('achievementsDates') as String? ?? '');
    dailyStepsCompletedInRowCount = savedData.get("dailyStepsCompletedInRowCount") as int? ?? 0;
    dailyStepsCompletedInRowLastDate = savedData.get("dailyStepsCompletedInRowLastDate") as int? ?? 0;
    upcomingScheduledReminder = savedData.get("upcomingScheduledReminder") as int? ?? 0;
    isDarkMode = savedData.get("isDarkMode") as bool? ?? true;
    isPushNotifications = savedData.get("isPushNotifications") as bool? ?? true;
    weight = savedData.get("weight") as num? ?? -1;
    height = savedData.get("height") as num? ?? -1;
    lastCompletedExercisesDate = DateTime.fromMillisecondsSinceEpoch(savedData.get('lastCompletedExercisesDate') as int? ?? DateTime.now().millisecondsSinceEpoch);
    workoutStreakStartDate = DateTime.fromMillisecondsSinceEpoch(savedData.get('workoutStreakStartDate') as int? ?? DateTime.now().millisecondsSinceEpoch);
    if (workoutScheduleNumber == -2) { // indicates a custom made schedule
      scheduleDailyExercises = savedData.get('customSchedule') as List<String>? ?? [];
    }
    lastCountDate20PercentDaysGoal = DateTime.fromMillisecondsSinceEpoch(savedData.get('lastCountDate20PercentDaysGoal') as int? ?? DateTime.now().millisecondsSinceEpoch);
    startDate20PercentDaysGoal = DateTime.fromMillisecondsSinceEpoch(savedData.get('startDate20PercentDaysGoal') as int? ?? DateTime.now().millisecondsSinceEpoch);
    lastCountDate50PercentDaysGoal = DateTime.fromMillisecondsSinceEpoch(savedData.get('lastCountDate50PercentDaysGoal') as int? ?? DateTime.now().millisecondsSinceEpoch);
    startDate50PercentDaysGoal = DateTime.fromMillisecondsSinceEpoch(savedData.get('startDate50PercentDaysGoal') as int? ?? DateTime.now().millisecondsSinceEpoch);
    lastCountDate100PercentDaysGoal = DateTime.fromMillisecondsSinceEpoch(savedData.get('lastCountDate100PercentDaysGoal') as int? ?? DateTime.now().millisecondsSinceEpoch);
    startDate100PercentDaysGoal = DateTime.fromMillisecondsSinceEpoch(savedData.get('startDate100PercentDaysGoal') as int? ?? DateTime.now().millisecondsSinceEpoch);

    int numberOfRegisters = 0;
    savedData.keys.forEach((key) {
      if (key.startsWith("stepCount")) {
        numberOfRegisters = max(int.parse(key.substring(9)), numberOfRegisters);
      }
    });
    for (int i = 0 ; i < numberOfRegisters ; i++) {
      stepsCountTimeline.add(savedData.get('stepCount${i+1}') ?? 0);
      stepsDateTimeline.add(savedData.get('stepDate${i+1}') ?? 0);
    }
    numberOfRegisters = 0;
    savedData.keys.forEach((key) {
      if (key.startsWith("burnedCalsCount")) {
        numberOfRegisters = max(int.parse(key.substring(15)), numberOfRegisters);
      }
    });
    for (int i = 0 ; i < numberOfRegisters ; i++) {
      burnedCalsCountTimeline.add(savedData.get('burnedCalsCount${i+1}') ?? 0);
      burnedCalsDateTimeline.add(savedData.get('burnedCalsDate${i+1}') ?? 0);
    }
  }

  static Future<void> writeAllData() async {
    if (Auth().currentUser!.email != null) {
      await DatabaseController.writeAllFields(Auth().currentUser!.email ?? '');
    }
    await writeAllPrefs();
  }

  static Future<void> writeAllPrefs() async {
    await savedData.put('workoutScheduleNumber', workoutScheduleNumber);
    await savedData.put('completionExercisesDate', completionExercisesDate.millisecondsSinceEpoch);
    await savedData.put('firstDayDateOfWorkoutSchedule', firstDayDateOfWorkoutSchedule.millisecondsSinceEpoch);
    await savedData.put('dailyStepsGoal', dailyStepsGoal);
    await savedData.put('completedExercises', getCompletedExercisesString());
    await savedData.put('todaySteps', todaySteps);
    await savedData.put('streakStartDate', streakStartDate.millisecondsSinceEpoch);
    await savedData.put('streakSeq', streakSeq);
    await savedData.put('achievementsDates', convertAchievementsDatesToString());
    await savedData.put('dailyStepsCompletedInRowCount', dailyStepsCompletedInRowCount);
    await savedData.put('dailyStepsCompletedInRowLastDate', dailyStepsCompletedInRowLastDate);
    await savedData.put('upcomingScheduledReminder', upcomingScheduledReminder);
    await savedData.put('isDarkMode', isDarkMode);
    await savedData.put('isPushNotifications', isPushNotifications);
    await savedData.put('weight', weight);
    await savedData.put('height', height);
    if (workoutScheduleNumber == -2) { // indicates a custom made schedule
      await savedData.put('customSchedule', scheduleDailyExercises);
    }
    await savedData.put('workoutStreakStartDate', workoutStreakStartDate.millisecondsSinceEpoch);
    await savedData.put('lastCompletedExercisesDate', lastCompletedExercisesDate.millisecondsSinceEpoch);

    await savedData.put('lastCountDate20PercentDaysGoal', lastCountDate20PercentDaysGoal.millisecondsSinceEpoch);
    await savedData.put('startDate20PercentDaysGoal', startDate20PercentDaysGoal.millisecondsSinceEpoch);
    await savedData.put('lastCountDate50PercentDaysGoal', lastCountDate50PercentDaysGoal.millisecondsSinceEpoch);
    await savedData.put('startDate50PercentDaysGoal', startDate50PercentDaysGoal.millisecondsSinceEpoch);
    await savedData.put('lastCountDate100PercentDaysGoal', lastCountDate100PercentDaysGoal.millisecondsSinceEpoch);
    await savedData.put('startDate100PercentDaysGoal', startDate100PercentDaysGoal.millisecondsSinceEpoch);

    for (int i = 0 ; i < stepsCountTimeline.length ; i++) {
      await savedData.put('stepCount${i+1}', stepsCountTimeline[i]);
      await savedData.put('stepDate${i+1}', stepsDateTimeline[i]);
    }

    for (int i = 0 ; i < burnedCalsCountTimeline.length ; i++) {
      await savedData.put('burnedCalsCount${i+1}', burnedCalsCountTimeline[i]);
      await savedData.put('burnedCalsDate${i+1}', burnedCalsDateTimeline[i]);
    }
  }

  static int findLastLessThanOneDayDifference(List<int> epochs) {
    var now = DateTime.now();
    for (int i = epochs.length - 1 ; i > -1 ; i--) {
      if (DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1)).isAfter(DateTime.fromMillisecondsSinceEpoch(epochs[i]))) {
        return ((i + 1) < epochs.length) ? (i + 1) : -1;
      }
    }

    return -1;
  }

  static int countSteps(List<int> stepsCounts, int start, int end) {
    int sum = 0;
    print("$start to $end");
    for (int i = start + 1 ; i < end ; i++) {
      if (stepsCounts[i] > stepsCounts[i - 1]) {
        sum += stepsCounts[i] - stepsCounts[i - 1];
      } else {
        sum += stepsCounts[i];
      }
    }
    return sum;
  }

  static int countCals(List<int> calsCount, int start, int end) {
    int sum = 0;
    for (int i = start + 1 ; i < end ; i++) {
      sum += calsCount[i];
    }
    return sum;
  }

  static void countTodaySteps() {
    int start = Main.findLastLessThanOneDayDifference(Main.stepsDateTimeline);
    print(Main.stepsDateTimeline);
    print(Main.stepsCountTimeline);
    if (start == -1) {
      if (Main.overallSteps > 0) {
        Main.todaySteps = Main.overallSteps;
      }
    } else {
      Main.todaySteps = Main.countSteps(
          Main.stepsCountTimeline, start, Main.stepsCountTimeline.length);
    }
    updateScheduleDay();
    StreakFinder.isEligibleToStreakTodayAndRegister();
    AchievementsController.checkDailyStepsGoalInRow();
    writeAllData();
  }

  static int countCompletedExercises() {
    int completed = 0;
    completedExercises.forEach((element) {
      if (element) {
        completed++;
      }
    });
    return completed;
  }

  static String getCompletedExercisesString() {
    String completions = "";
    Main.completedExercises.forEach((element) {
      completions += element ? '1' : '0';
    });
    return completions;
  }

  static void setCompletedExercisesString(String completions) {
    for (int i = 0 ; i < completions.length ; i++) {
      Main.completedExercises.add(completions[i] == '0' ? false : true);
    }
  }

  static List<int> processAchievementsDates(String str) {
    if (str.isNotEmpty) {
      List<int> toReturn = [];
      str.split(',').forEach((dateStr) {
        if (dateStr == '0') {
          toReturn.add(0);
        } else {
          print(dateStr);
          var x = dateStr.split('-');
          toReturn.add(DateTime(int.parse(x[0]), int.parse(x[1]), int.parse(x[2])).millisecondsSinceEpoch);
        }
      });
      return toReturn;
    } else {
      return List.filled(33, 0);
    }
  }

  static String convertAchievementsDatesToString() {
    String toReturn = '';
    achievementsDates.forEach((date) {
      if (date == 0) {
        toReturn += '0,';
      } else {
        var date_ = DateTime.fromMillisecondsSinceEpoch(date);
        toReturn += '${date_.year}-${date_.month}-${date_.day},';
      }
    });
    toReturn = toReturn.substring(0, toReturn.length - 1);

    return toReturn;
  }

  static void updateScheduleDay() {
    if (Main.scheduleDailyExercises.isNotEmpty) {
      var x = Main.daysBetweenWeekdays(Main.firstDayDateOfWorkoutSchedule, DateTime.now()) + 1;
      if (Main.currentWorkoutScheduleDay != x) {
        Main.currentWorkoutScheduleDay = x;
        Main.completionExercisesDate = DateTime.now();
        HomePageState.currState.updatePage();
      }
      int index = Main.currentWorkoutScheduleDay - 1;
      if (index < Main.scheduleDailyExercises.length) {
        int titleSepIndex = Main.scheduleDailyExercises[index].indexOf(':');
        HomePageState.dayTitle = (Main.scheduleDailyExercises[index].substring(0, titleSepIndex));
      }
    }
  }

  static Future<String> getLastActiveEmail() async {
    return (await Hive.openBox('MeFit')).get('lastEmail') as String? ?? '';
  }

  static Future<void> setLastActiveEmail(String email) async {
    await (await Hive.openBox('MeFit')).put('lastEmail', email);
  }

  static Future<void> initializeLocalDB() async {
    String lastUserEmail = await Main.getLastActiveEmail();
    if (lastUserEmail.isNotEmpty) {
      Main.savedData = await Hive.openBox('MeFit-$lastUserEmail');
    } else {
      Main.savedData = await Hive.openBox('MeFit');
    }
  }

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white
        ),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group'
        )
      ],
      debug: false
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {

  static State? currentState;

  @override
  void initState() {
    super.initState();

    AwesomeNotifications().setListeners(
        onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    );

    currentState = this;
  }

@override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: Main.isDarkMode ? ThemeData.dark() : ThemeData.light(),
    title: 'MeFit',
    home: FutureBuilder(
      future: Main.fApp,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Widget page = Scaffold(
            body: Center(
              child: Text("Something went wrong with Firebase!\n${snapshot.error ?? ''}"),
            ),
          );
          return page;
        } else if (snapshot.hasData) {
          return Auth().currentUser == null ? const LoginPage() : (Main.isAccountRegistered ? const HomePage() : const FillProfileInfoPage());
        } else {
          return const Scaffold(
            body: Center(
                child: CircularProgressIndicator()
            ),
          );
        }

      },
    ),
  );
}

}
