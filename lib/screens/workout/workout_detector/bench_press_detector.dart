import 'dart:math';

import 'package:Vyayama/resource/logger/logger.dart';
import 'package:Vyayama/screens/workout/workout_detector/base_workout_detector.dart';
import 'package:Vyayama/screens/workout/workout_detector/interface/i_workout_detector_call_back.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class BenchPressDetector extends BaseWorkoutDetector {
  final IWorkoutDetectorCallback _callback;
  WorkoutProgressStatus? _previousProgressStatus = WorkoutProgressStatus.init;

  BenchPressDetector(this._callback) : super(_callback);

  // Function to calculate angle between three landmarks
  double calculateAngle(
      PoseLandmark? pointA, PoseLandmark? pointB, PoseLandmark? pointC) {
    if (pointA == null || pointB == null || pointC == null) return 180;

    // Calculate the angle in radians and then convert to degrees
    final radians = atan2(pointC.y - pointB.y, pointC.x - pointB.x) -
        atan2(pointA.y - pointB.y, pointA.x - pointB.x);

    double angle = radians * (180 / pi);

    // Normalize the angle to be between 0 and 360 degrees
    if (angle < 0) angle += 360;

    // Normalize further to ensure angle is between 0 and 180 degrees
    if (angle > 180) angle = 360 - angle;

    return angle;
  }

  @override
  void checkTheStatusOfPoses(List<Pose> poses) {
    WorkoutProgressStatus? currentBenchPressStatus;
    if (poses.isEmpty) {
      appLogger.debug('No Person Found');
      return _callback.noPersonFound();
    }

    final Pose pose = poses.first;

    final PoseLandmark? leftShoulder =
        pose.landmarks[PoseLandmarkType.leftShoulder];
    final PoseLandmark? rightShoulder =
        pose.landmarks[PoseLandmarkType.rightShoulder];
    final PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
    final PoseLandmark? rightElbow =
        pose.landmarks[PoseLandmarkType.rightElbow];
    final PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
    final PoseLandmark? rightWrist =
        pose.landmarks[PoseLandmarkType.rightWrist];

    if (leftShoulder == null ||
        rightShoulder == null ||
        leftElbow == null ||
        rightElbow == null ||
        leftWrist == null ||
        rightWrist == null) {
      appLogger.debug('One or more landmarks are missing');
      return;
    }

    // Calculate the arm angles
    final double leftArmAngle =
        calculateAngle(leftShoulder, leftElbow, leftWrist);
    final double rightArmAngle =
        calculateAngle(rightShoulder, rightElbow, rightWrist);

    // Define thresholds for pressing and lowering phases
    // Lowering phase: Arms bent, elbow angles smaller (<90 degrees)
    final bool loweringPhase = (leftArmAngle < 90 && rightArmAngle < 90);

    // Pressing phase: Arms straight, elbow angles larger (>150 degrees)
    final bool pressingPhase = (leftArmAngle > 150 && rightArmAngle > 150);

    appLogger.debug(
        'BenchPressDetector : Left Arm Angle: $leftArmAngle, Right Arm Angle: $rightArmAngle');

    if (loweringPhase) {
      appLogger.debug('BenchPressDetector: Bench Press: Lowering');
      currentBenchPressStatus = WorkoutProgressStatus.middlePose;
    } else if (pressingPhase) {
      appLogger.debug('BenchPressDetector: Bench Press: Pressing');
      if (_previousProgressStatus == null ||
          _previousProgressStatus == WorkoutProgressStatus.init) {
        currentBenchPressStatus = WorkoutProgressStatus.init;
      } else {
        currentBenchPressStatus = WorkoutProgressStatus.finalPose;
      }
    }

    appLogger.debug(
        'Bench Press: previous $_previousProgressStatus current $currentBenchPressStatus');

    if (_previousProgressStatus == WorkoutProgressStatus.middlePose &&
        currentBenchPressStatus == WorkoutProgressStatus.finalPose) {
      totalReps++;
      _callback.onWorkoutCompleted(totalReps);
      appLogger.debug('Total Bench Presses: $totalReps');
    }

    if (currentBenchPressStatus != null) {
      _callback.onPoseStatusChanged(currentBenchPressStatus);
      _previousProgressStatus = currentBenchPressStatus;
    }
  }
}
