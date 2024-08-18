
class Achievement {
  int index;
  String description;
  String badgeDescription;

  bool isCompleted;
  DateTime dateOfCompletion;

  Achievement({required this.index, required this.description, required this.badgeDescription,
  required this.isCompleted, required this.dateOfCompletion});
}
