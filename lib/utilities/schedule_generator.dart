import 'package:csv/csv.dart';
import 'dart:math';

import 'package:flutter/services.dart';

class ScheduleGenerator {

  String weightClass; // 1 - 5, skinny to Obese

  String pastExerciseRegularity;
  String exercisingGoal;
  int dailyExercisingDuration;
  int weeklyExercisingDays;
  bool isGymAvailable;
  int age;
  String sex;

  int weightClassNum = 1; // skinny by default
  int last6MonthsRegularity = 1; // never by default
  String exercisingArea = "Gym";

  static const weightClassNumbered = {
    "Skinny" : 1,
    "Underweight" : 2,
    "Average" : 3,
    "Overweight" : 4,
    "Obese" : 5,
  };

  static const regularityNumbered = {
    "Never" : 1,
    "Rarely" : 2,
    "Regularly" : 3,
    "Always" : 4,
  };

  ScheduleGenerator({required this.weightClass, required this.pastExerciseRegularity,
  required this.exercisingGoal, required this.dailyExercisingDuration,
  required this.weeklyExercisingDays, required this.isGymAvailable,
  required this.age, required this.sex}) {
    weightClassNum = weightClassNumbered[weightClass]!;
    last6MonthsRegularity = regularityNumbered[pastExerciseRegularity]!;
    exercisingArea = isGymAvailable ? "Gym" : "Home";
  }

  Future<int> generateScheduleNumber() async {
    var dataset = await _readDataset();
    dataset.add([age.toString(), sex, weightClassNum.toString(),
      dailyExercisingDuration.toString(), weeklyExercisingDays.toString(),
      last6MonthsRegularity.toString(), exercisingArea, exercisingGoal, 1]);

    tokenMap = _tokenizeMatrix(dataset);
    tokenMap?.forEach((key, value) {print(value);});

    var datasetTokenized = _convertMatrixToNumbers(dataset, tokenMap!);
    var datasetNormalized = _normalizeDataset(datasetTokenized);

    var set = datasetNormalized.removeLast();
    set.removeLast();

    return _generateSchedule(datasetNormalized, set, 1);
  }

  Future<List<List>> _readDataset() async {

    final input = await rootBundle.loadString("assets/data/dataset.csv");
    var dataset = const CsvToListConverter().convert(input, shouldParseNumbers: false, textDelimiter: '"',  fieldDelimiter: ',', eol: '\n');
    dataset.removeAt(0); // remove the header
    return dataset;

  }

  Map<int, Map<dynamic, int>> _tokenizeMatrix(List<List<dynamic>> matrix) {
    // Initialize a map to store tokens for each column
    Map<int, Map<dynamic, int>> tokens = {};
    int nextToken = 0; // Counter for assigning unique tokens

    // Iterate through each column
    for (int col = 0; col < matrix[0].length; col++) {
      tokens[col] = {}; // Create a map for each column's tokens
      Set<dynamic> uniqueValues = {}; // Set to store unique values in the column

      // Collect unique values in the current column
      for (int row = 0; row < matrix.length; row++) {
        uniqueValues.add(matrix[row][col]);
      }

      // Assign tokens to unique values
      for (var value in uniqueValues) {
        tokens[col]?[value] = nextToken++;
      }
    }

    return tokens;
  }

  Map<int, Map<dynamic, int>>? tokenMap;

  void calculateAccuracy() async {

    var dataset = await _readDataset();
    tokenMap = _tokenizeMatrix(dataset);
    var datasetTokenized = _convertMatrixToNumbers(dataset, tokenMap!);
    var datasetNormalized = _normalizeDataset(datasetTokenized);

    int trues = 0, wrongs = 0;
    int k = 1;

    for (int i = 0 ; i < datasetNormalized.length ; i++) {
      List<List<num>> ds = _normalizeDataset(datasetTokenized); // for some reason, I had to normalize the data every loop as it is getting corrupted after generateSchedule gets called
      var set = ds.removeAt(i);
      num toPredict = set.removeLast();
      int sch = _generateSchedule(ds, set, k);
      print("resulted $sch, the actual target is $toPredict");
      if (sch == toPredict) {
        trues++;
      } else {
        wrongs++;
      }
    }
    double accuracy = (trues) / (trues + wrongs);
    print("\n\nAccuracy of k = $k is $accuracy\n\n");

  }

  int _generateSchedule(List<List<dynamic>> ds_, List<dynamic> set, int k) {

    List<List<dynamic>> distances =
    ds_.map((row) => [_calculateDistance(row, set), row.last]).toList();

// Sort distances in ascending order
    distances.sort((a, b) => a[0].compareTo(b[0]));

// Get the labels of the k nearest neighbors
    List<dynamic> kNeighborLabels = distances.take(k).map((row) => row[1]).toList();

// Find the most frequent label among the k neighbors
    Map<dynamic, int> labelCounts = {};
    for (var label in kNeighborLabels) {
      labelCounts[label] = (labelCounts[label] ?? 0) + 1;
    }

    dynamic mostFrequentLabel = labelCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return mostFrequentLabel is double ? mostFrequentLabel.toInt() : mostFrequentLabel;
  }

  List<List<num>> _normalizeDataset(List<List<dynamic>> dataset) {
    // Find the minimum and maximum values for each column (excluding the last)
    int numCols = dataset[0].length;
    List<num> mins = List.generate(numCols - 1, (i) => dataset.map((row) => row[i]).reduce((a, b) => a < b ? a : b));
    List<num> maxs = List.generate(numCols - 1, (i) => dataset.map((row) => row[i]).reduce((a, b) => a > b ? a : b));

    // Normalize each data point (excluding the last column)
    List<List<num>> normalizedDataset = [];
    for (List<dynamic> row in dataset) {
      List<num> normalizedRow = [];
      for (int i = 0; i < numCols - 1; i++) {
        normalizedRow.add(((row[i] as num) - mins[i]) / (maxs[i] - mins[i]));
      }
      // Add the last column without modification
      normalizedRow.addAll(row.skip(numCols - 1) as Iterable<num>);
      normalizedDataset.add(normalizedRow);
    }

    return normalizedDataset;
  }

  String _workoutPlaceToStr(double n) { // if the tokenization and normalization functions remains the same, these integers will always refer to these strings
    switch (n) {
      case 1: // 94
        return "Home";
      case 0: // 93
        return "Gym";
    }
    return "ERROR!";
  }

  num _calculateDistance(List<dynamic> row1, List<dynamic> row2) { // if the days dont match or the workout place does not match too, then make the distance as max
    num sumOfSquaredDifferences = 0;
    row1 = [...row1];row2 = [...row2]; // solves a bug found, I should have used python

    String row1ExercisePlace = _workoutPlaceToStr(row1[6]);
    String row2ExercisePlace = _workoutPlaceToStr(row2[6]);
    if (row1[4] != row2[4] || !(row1ExercisePlace == "Home" ?
    (row2ExercisePlace == "Home") : row2ExercisePlace != "Home")) {
      return double.maxFinite;
    }

    // remove the filtered parameters from the top:
    row1.removeAt(6);row2.removeAt(6);
    row1.removeAt(4);row2.removeAt(4);
    List<double> weights = [3.1, 0.47, 1.2, 0, 4.1, 25]; // [age, sex, weight class, daily minutes, workout regularity, workout purpose]
    for (int i = 0; i < row1.length - 1; i++) {
      sumOfSquaredDifferences += pow(weights[i] * (row1[i] - row2[i]), 2);
    }
    return sqrt(sumOfSquaredDifferences); // [0.46153846153846156, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2857142857142857]
  }

  List<List<int>> _convertMatrixToNumbers(List<List<dynamic>> matrix, Map<int, Map<dynamic, int>> tokenMap) {
    List<List<int>> tokenizedMatrix = List.generate(matrix.length, (_) => List.filled(matrix[0].length, 0));

    for (int row = 0; row < matrix.length; row++) {
      for (int col = 0; col < matrix[row].length; col++) {
        if (col == matrix[row].length - 1) {
          tokenizedMatrix[row][col] = int.parse(matrix[row][col].toString());
        } else if (matrix[row][col] is! double && matrix[row][col] is! int) {
          tokenizedMatrix[row][col] = tokenMap[col]?[matrix[row][col]] ?? 0;
        } else {
          tokenizedMatrix[row][col] = matrix[row][col];
        }
      }
    }

    return tokenizedMatrix;
  }

}
