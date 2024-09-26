import 'dart:math';

import 'package:Vyayama/resource/logger/logger.dart';
import 'package:Vyayama/screens/workout/workout_detector/base_workout_detector.dart';
import 'package:Vyayama/screens/workout/workout_detector/interface/i_workout_detector_call_back.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class DeadliftDetector extends BaseWorkoutDetector {
  final IWorkoutDetectorCallback _callback;
  WorkoutProgressStatus? _previousProgressStatus = WorkoutProgressStatus.init;

  DeadliftDetector(this._callback) : super(_callback);

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
    WorkoutProgressStatus? currentDeadliftStatus;
    if (poses.isEmpty) {
      appLogger.debug('No Person Found');
      return _callback.noPersonFound();
    }

    final Pose pose = poses.first;

    final PoseLandmark? leftShoulder =
        pose.landmarks[PoseLandmarkType.leftShoulder];
    final PoseLandmark? rightShoulder =
        pose.landmarks[PoseLandmarkType.rightShoulder];
    final PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
    final PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
    final PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
    final PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];
    final PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
    final PoseLandmark? rightAnkle =
        pose.landmarks[PoseLandmarkType.rightAnkle];

    if (leftShoulder == null ||
        rightShoulder == null ||
        leftHip == null ||
        rightHip == null ||
        leftKnee == null ||
        rightKnee == null ||
        leftAnkle == null ||
        rightAnkle == null) {
      appLogger.debug('One or more landmarks are missing');
      return;
    }

    // Calculate angles for hip and knee
    final double leftHipAngle = calculateAngle(leftShoulder, leftHip, leftKnee);
    final double rightHipAngle =
        calculateAngle(rightShoulder, rightHip, rightKnee);
    final double leftKneeAngle = calculateAngle(leftHip, leftKnee, leftAnkle);
    final double rightKneeAngle =
        calculateAngle(rightHip, rightKnee, rightAnkle);

    // Adjusted thresholds for deadlift phases
    // Lifting phase: Hips extending (hip angle > 165) and knees straightening (knee angle > 165)
    final bool liftingPhase = (leftHipAngle > 165 && rightHipAngle > 165) &&
        (leftKneeAngle > 165 && rightKneeAngle > 165);

    // Lowering phase: Hips flexing (hip angle < 160) and knees bending (knee angle < 160)
    final bool loweringPhase = (leftHipAngle < 160 && rightHipAngle < 160) &&
        (leftKneeAngle < 160 && rightKneeAngle < 160);

    appLogger.debug(
        'DeadliftDetector: Left Hip Angle: $leftHipAngle, Right Hip Angle: $rightHipAngle');
    appLogger.debug(
        'DeadliftDetector: Left Knee Angle: $leftKneeAngle, Right Knee Angle: $rightKneeAngle');

    if (loweringPhase) {
      appLogger.debug('DeadliftDetector: Deadlift: Lowering');
      currentDeadliftStatus = WorkoutProgressStatus.middlePose;
    } else if (liftingPhase) {
      appLogger.debug('DeadliftDetector: Deadlift: Lifting');
      if (_previousProgressStatus == WorkoutProgressStatus.init) {
        currentDeadliftStatus = WorkoutProgressStatus.init;
      } else {
        currentDeadliftStatus = WorkoutProgressStatus.finalPose;
      }
    }

    appLogger.debug(
        'Deadlift : previous $_previousProgressStatus current $currentDeadliftStatus');

    // Counting rep when transitioning from lowering to lifting phase
    if (_previousProgressStatus == WorkoutProgressStatus.middlePose &&
        currentDeadliftStatus == WorkoutProgressStatus.finalPose) {
      totalReps++;
      _callback.onWorkoutCompleted(totalReps);
      appLogger.debug('Total Deadlifts: $totalReps');
    }

    if (currentDeadliftStatus != null) {
      _callback.onPoseStatusChanged(currentDeadliftStatus);
      _previousProgressStatus = currentDeadliftStatus;
    }
  }
}
