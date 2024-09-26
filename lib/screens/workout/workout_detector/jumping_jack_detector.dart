import 'package:Vyayama/resource/logger/logger.dart';
import 'package:Vyayama/screens/workout/workout_detector/base_workout_detector.dart';
import 'package:Vyayama/screens/workout/workout_detector/interface/i_workout_detector_call_back.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class JumpingJackDetector extends BaseWorkoutDetector {
  final IWorkoutDetectorCallback _callback;
  WorkoutProgressStatus? _previousProgressStatus = WorkoutProgressStatus.init;

  JumpingJackDetector(this._callback) : super(_callback);

  @override
  void checkTheStatusOfPoses(List<Pose> poses) {
    WorkoutProgressStatus? currentJumpingJackStatus;
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
    final PoseLandmark? leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
    final PoseLandmark? rightAnkle =
        pose.landmarks[PoseLandmarkType.rightAnkle];
    final PoseLandmark? leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
    final PoseLandmark? rightWrist =
        pose.landmarks[PoseLandmarkType.rightWrist];

    if (leftShoulder == null ||
        rightShoulder == null ||
        leftHip == null ||
        rightHip == null ||
        leftAnkle == null ||
        rightAnkle == null ||
        leftWrist == null ||
        rightWrist == null) {
      appLogger.debug('One or more landmarks are missing');
      return;
    }

    final double shoulderDistance = (leftShoulder.x - rightShoulder.x).abs();
    final double hipDistance = (leftHip.x - rightHip.x).abs();
    final double ankleDistance = (leftAnkle.x - rightAnkle.x).abs();
    final bool handsAboveShoulders =
        leftWrist.y < leftShoulder.y && rightWrist.y < rightShoulder.y;

    appLogger.debug('Hands Above Shoulders: $handsAboveShoulders');
    appLogger.debug('Shoulder Distance: $shoulderDistance');
    appLogger.debug('Hip Distance: $hipDistance');
    appLogger.debug('Ankle Distance: $ankleDistance');

    if (ankleDistance > hipDistance * 1.5 && handsAboveShoulders) {
      appLogger.debug('Jumping Jacks: Jump Out');
      currentJumpingJackStatus = WorkoutProgressStatus.middlePose;
    } else if (ankleDistance < shoulderDistance * 1.2 && !handsAboveShoulders) {
      appLogger.debug('Jumping Jacks: Jump In');
      // The first status is detected as Jump In, that means the person is still at the starting position
      if (_previousProgressStatus == null ||
          _previousProgressStatus == WorkoutProgressStatus.init) {
        currentJumpingJackStatus = WorkoutProgressStatus.init;
      } else {
        currentJumpingJackStatus = WorkoutProgressStatus.finalPose;
      }
    }

    appLogger.debug(
        'Jumping Jacks: previous $_previousProgressStatus current $currentJumpingJackStatus');

    if (_previousProgressStatus == WorkoutProgressStatus.middlePose &&
        currentJumpingJackStatus == WorkoutProgressStatus.finalPose) {
      totalReps++;
      _callback.onWorkoutCompleted(totalReps);
      appLogger.debug('Total Jumping Jacks: $totalReps');
    }

    if (currentJumpingJackStatus != null) {
      _callback.onPoseStatusChanged(currentJumpingJackStatus);
      _previousProgressStatus = currentJumpingJackStatus;
    }
  }
}
