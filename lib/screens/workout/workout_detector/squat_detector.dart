import 'dart:math';

import 'package:Vyayama/resource/logger/logger.dart';
import 'package:Vyayama/screens/workout/workout_detector/base_workout_detector.dart';
import 'package:Vyayama/screens/workout/workout_detector/interface/i_workout_detector_call_back.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class SquatDetector extends BaseWorkoutDetector {
  final IWorkoutDetectorCallback _callback;
  WorkoutProgressStatus? _previousProgressStatus = WorkoutProgressStatus.init;

  SquatDetector(this._callback) : super(_callback);

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
    WorkoutProgressStatus? currentSquatStatus;
    if (poses.isEmpty) {
      appLogger.debug('No Person Found');
      return _callback.noPersonFound();
    }

    final Pose pose = poses.first;

    // Using Shoulder, Hip, and Knee to calculate hip angle
    final PoseLandmark? leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
    final PoseLandmark? rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
    final PoseLandmark? leftHip = pose.landmarks[PoseLandmarkType.leftHip];
    final PoseLandmark? rightHip = pose.landmarks[PoseLandmarkType.rightHip];
    final PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
    final PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];

    if (leftHip == null ||
        rightHip == null ||
        leftShoulder == null ||
        rightShoulder == null ||
        leftKnee == null ||
        rightKnee == null) {
      appLogger.debug('One or more landmarks are missing');
      return;
    }

    // Correctly calculate hip angles using Shoulder-Hip-Knee for squats
    final double leftHipAngle = calculateAngle(leftShoulder, leftHip, leftKnee);
    final double rightHipAngle = calculateAngle(rightShoulder, rightHip, rightKnee);
    final double leftKneeAngle = calculateAngle(leftHip, leftKnee, pose.landmarks[PoseLandmarkType.leftAnkle]);
    final double rightKneeAngle = calculateAngle(rightHip, rightKnee, pose.landmarks[PoseLandmarkType.rightAnkle]);

    // Define thresholds for squat phases
    // Lifting phase: Hips extending (hip angle > 160 and knee angle > 160)
    final bool liftingPhase = (leftHipAngle > 160 && rightHipAngle > 160) &&
        (leftKneeAngle > 160 && rightKneeAngle > 160);

    // Lowering phase: Hips flexing (hip angle < 120 and knee angle < 120)
    final bool loweringPhase = (leftHipAngle < 120 && rightHipAngle < 120) &&
        (leftKneeAngle < 120 && rightKneeAngle < 120);

    appLogger.debug(
        'SquatDetector : Left Hip Angle: $leftHipAngle, Right Hip Angle: $rightHipAngle');
    appLogger.debug(
        'SquatDetector : Left Knee Angle: $leftKneeAngle, Right Knee Angle: $rightKneeAngle');

    if (loweringPhase) {
      appLogger.debug('SquatDetector: Squat: Lowering');
      currentSquatStatus = WorkoutProgressStatus.middlePose;
    } else if (liftingPhase) {
      appLogger.debug('SquatDetector: Squat: Lifting');
      if (_previousProgressStatus == WorkoutProgressStatus.init) {
        currentSquatStatus = WorkoutProgressStatus.init;
      } else {
        currentSquatStatus = WorkoutProgressStatus.finalPose;
      }
    }

    appLogger.debug(
        'Squat : previous $_previousProgressStatus current $currentSquatStatus');

    if (_previousProgressStatus == WorkoutProgressStatus.middlePose &&
        currentSquatStatus == WorkoutProgressStatus.finalPose) {
      totalReps++;
      _callback.onWorkoutCompleted(totalReps);
      appLogger.debug('Total Squats: $totalReps');
    }

    if (currentSquatStatus != null) {
      _callback.onPoseStatusChanged(currentSquatStatus);
      _previousProgressStatus = currentSquatStatus;
    }
  }
}
