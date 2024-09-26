import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutRecord {
  final String workoutID;
  final DateTime date;
  final List<SetRecord> sets;

  WorkoutRecord({
    required this.workoutID,
    required this.date,
    required this.sets,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'sets': sets.map((set) => set.toMap()).toList(),
    };
  }

  static WorkoutRecord fromMap(String workoutID, Map<String, dynamic> data) {
    return WorkoutRecord(
      workoutID: workoutID,
      date: (data['date'] as Timestamp).toDate(),
      sets: (data['sets'] as List)
          .map((set) => SetRecord.fromMap(set as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SetRecord {
  final int reps;
  final double weight;

  SetRecord({
    required this.reps,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'reps': reps,
      'weight': weight,
    };
  }

  static SetRecord fromMap(Map<String, dynamic> data) {
    return SetRecord(
      reps: data['reps'],
      weight: data['weight'].toDouble(),
    );
  }
}
