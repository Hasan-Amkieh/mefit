
class UserInfo {

  int workoutScheduleNumber;
  DateTime firstDayDateOfWorkoutSchedule;
  List<bool> completedExercises;
  int dailyStepsGoal;
  DateTime completionExercisesDate;
  List<int> stepsCountTimeline;
  List<int> stepsDateTimeline;
  int todaySteps;
  DateTime streakStartDate;
  String streakSeq;
  List<int> burnedCalsCountTimeline;
  List<int> burnedCalsDateTimeline;
  List<int> achievementsDates;
  int upcomingScheduledReminder;
  int dailyStepsCompletedInRowCount;
  int dailyStepsCompletedInRowLastDate;

  UserInfo({required this.workoutScheduleNumber, required this.firstDayDateOfWorkoutSchedule,
  required this.completedExercises, required this.dailyStepsGoal, required this.completionExercisesDate,
  required this.stepsCountTimeline, required this.stepsDateTimeline, required this.todaySteps,
  required this.streakSeq, required this.burnedCalsDateTimeline, required this.burnedCalsCountTimeline,
  required this.achievementsDates, required this.upcomingScheduledReminder, required this.streakStartDate,
  required this.dailyStepsCompletedInRowLastDate, required this.dailyStepsCompletedInRowCount});

}
