import 'dart:math';

import 'package:Vyayama/resource/logger/logger.dart';
import 'package:Vyayama/screens/workout/workout_detector/base_workout_detector.dart';
import 'package:Vyayama/screens/workout/workout_detector/interface/i_workout_detector_call_back.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class BarbellRowDetector extends BaseWorkoutDetector {
  final IWorkoutDetectorCallback _callback;
  WorkoutProgressStatus? _previousProgressStatus = WorkoutProgressStatus.init;

  BarbellRowDetector(this._callback) : super(_callback);

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
    WorkoutProgressStatus? currentBarbellRowStatus;
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
    final PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
    final PoseLandmark? rightWrist =
        pose.landmarks[PoseLandmarkType.rightWrist];
    final PoseLandmark? leftElbow = pose.landmarks[PoseLandmarkType.leftElbow];
    final PoseLandmark? rightElbow =
        pose.landmarks[PoseLandmarkType.rightElbow];
    final PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
    final PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];

    if (leftShoulder == null ||
        rightShoulder == null ||
        leftHip == null ||
        rightHip == null ||
        leftWrist == null ||
        rightWrist == null ||
        leftElbow == null ||
        rightElbow == null ||
        leftKnee == null ||
        rightKnee == null) {
      appLogger.debug('One or more landmarks are missing');
      return;
    }

    // Calculate normalized angles
    final double leftBackAngle =
        calculateAngle(leftShoulder, leftHip, leftKnee);
    final double rightBackAngle =
        calculateAngle(rightShoulder, rightHip, rightKnee);
    final double leftArmAngle =
        calculateAngle(leftShoulder, leftElbow, leftWrist);
    final double rightArmAngle =
        calculateAngle(rightShoulder, rightElbow, rightWrist);

    // Adjust thresholds for bent over position based on new insights
    final bool bentOverPosition = (leftBackAngle > 90 && leftBackAngle < 140) &&
        (rightBackAngle > 90 && rightBackAngle < 140);

    // Adjusting the threshold for pulling phase to < 120 degrees to be less strict
    final bool pullingPhase = (leftArmAngle < 120 &&
        rightArmAngle < 120); // Increased threshold to <120 degrees
    final bool loweringPhase = (leftArmAngle > 150 &&
        rightArmAngle > 150); // Arms almost straight = lowering

    appLogger
        .debug('BarbellRowDetector : Bent Over Position: $bentOverPosition');
    appLogger.debug(
        'BarbellRowDetector : Left Back Angle: $leftBackAngle, Right Back Angle: $rightBackAngle');
    appLogger.debug(
        'BarbellRowDetector : Left Arm Angle: $leftArmAngle, Right Arm Angle: $rightArmAngle');

    if (bentOverPosition && pullingPhase) {
      appLogger.debug('BarbellRowDetector: Barbell Row: Pulling');
      currentBarbellRowStatus = WorkoutProgressStatus.middlePose;
    } else if (bentOverPosition && loweringPhase) {
      appLogger.debug('BarbellRowDetector: Barbell Row: Lowering');
      if (_previousProgressStatus == null ||
          _previousProgressStatus == WorkoutProgressStatus.init) {
        currentBarbellRowStatus = WorkoutProgressStatus.init;
      } else {
        currentBarbellRowStatus = WorkoutProgressStatus.finalPose;
      }
    }

    appLogger.debug(
        'Barbell Row: previous $_previousProgressStatus current $currentBarbellRowStatus');

    if (_previousProgressStatus == WorkoutProgressStatus.middlePose &&
        currentBarbellRowStatus == WorkoutProgressStatus.finalPose) {
      totalReps++;
      _callback.onWorkoutCompleted(totalReps);
      appLogger.debug('Total Barbell Rows: $totalReps');
    }

    if (currentBarbellRowStatus != null) {
      _callback.onPoseStatusChanged(currentBarbellRowStatus);
      _previousProgressStatus = currentBarbellRowStatus;
    }
  }
}
