import 'package:Vyayama/screens/home/workout_detector/base_workout_detector.dart';
import 'package:flutter/widgets.dart';

abstract class IWorkoutDetectorCallback {
  void noPersonFound();

  void onPoseDetected(CustomPaint customPaint);

  void onPoseStatusChanged(WorkoutProgressStatus status);

  void onWorkoutCompleted(int count);
}
