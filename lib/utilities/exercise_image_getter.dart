import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class ExerciseImageGetter {

  static List<List<String>> exercisesList = [];
  static bool isLoaded = false;

  ExerciseImageGetter() {
    if (exercisesList.isEmpty) {
      rootBundle.loadString('assets/data/exercises_description.csv').then((value) {
        for (List<String> exercise in const CsvToListConverter().convert(value, shouldParseNumbers: false, textDelimiter: '"',  fieldDelimiter: ',', eol: '\n')) {
          if (exercise[5].trim() != '-') {
            exercisesList.add([exercise[0], exercise[5].trim()]);
          }
        }
        isLoaded = true;
      });
    }
  }

  String getImagePath(String exerciseName) {
    exerciseName = exerciseName.toLowerCase().trim();
    if (isLoaded) {
      String toReturn = '';
      exercisesList.forEach((exercise) {
        if (exercise[0].toLowerCase() == exerciseName ||
            exercise[0].toLowerCase() == '${exerciseName}s') {
          toReturn = 'workouts/${exercise[0].replaceAll(' ', '_')}.${exercise[1]}';
          return ;
        }
      });
      if (toReturn.isNotEmpty) {
        return toReturn;
      }
    }

    return 'workouts/default.webp';
  }

}
