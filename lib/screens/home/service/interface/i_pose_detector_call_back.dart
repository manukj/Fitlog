import 'package:Vyayama/screens/home/service/post_detector_service.dart';
import 'package:flutter/widgets.dart';

abstract class IPoseDetectorCallback {
  void noPersonFound();

  void onPoseDetected(CustomPaint customPaint);

  void onPoseStatusChanged(WorkoutProgressStatus status);

  void onWorkoutCompleted(int count);
}
