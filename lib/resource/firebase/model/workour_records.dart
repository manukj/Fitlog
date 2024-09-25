import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutRecord {
  final String workoutID;
  final DateTime date;
  final int reps;
  final double weight;

  WorkoutRecord({
    required this.workoutID,
    required this.date,
    required this.reps,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'reps': reps,
      'weight': weight,
    };
  }

  static WorkoutRecord fromMap(String workoutID, Map<String, dynamic> data) {
    return WorkoutRecord(
      workoutID: workoutID,
      date: (data['date'] as Timestamp).toDate(),
      reps: data['reps'],
      weight: data['weight'].toDouble(),
    );
  }
}
