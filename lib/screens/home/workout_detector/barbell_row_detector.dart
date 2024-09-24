import 'package:Vyayama/resource/logger/logger.dart';
import 'package:Vyayama/screens/home/workout_detector/base_workout_detector.dart';
import 'package:Vyayama/screens/home/workout_detector/interface/i_workout_detector_call_back.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class BarbellRowDetector extends BaseWorkoutDetector {
  final IWorkoutDetectorCallback _callback;
  WorkoutProgressStatus? _previousProgressStatus = WorkoutProgressStatus.init;

  BarbellRowDetector(this._callback) : super(_callback);

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
    final PoseLandmark? leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
    final PoseLandmark? rightKnee = pose.landmarks[PoseLandmarkType.rightKnee];

    if (leftShoulder == null ||
        rightShoulder == null ||
        leftHip == null ||
        rightHip == null ||
        leftWrist == null ||
        rightWrist == null ||
        leftKnee == null ||
        rightKnee == null) {
      appLogger.debug('One or more landmarks are missing');
      return;
    }

    // Calculate important distances and angles
    final double shoulderY = (leftShoulder.y + rightShoulder.y) / 2;
    final double wristY = (leftWrist.y + rightWrist.y) / 2;
    final double hipY = (leftHip.y + rightHip.y) / 2;
    final double kneeY = (leftKnee.y + rightKnee.y) / 2;

    // Conditions to identify phases of the Barbell Row
    final bool bentOverPosition = hipY < shoulderY && kneeY < hipY;
    final bool pullingPhase = wristY < hipY; // Hands above hips implies pulling the barbell up
    final bool loweringPhase = wristY > hipY; // Hands below hips implies lowering the barbell

    appLogger.debug('Bent Over Position: $bentOverPosition');
    appLogger.debug('Wrist Y: $wristY, Hip Y: $hipY, Shoulder Y: $shoulderY');

    if (bentOverPosition && pullingPhase) {
      appLogger.debug('Barbell Row: Pulling');
      currentBarbellRowStatus = WorkoutProgressStatus.middlePose;
    } else if (bentOverPosition && loweringPhase) {
      appLogger.debug('Barbell Row: Lowering');
      // First status is detected as Lowering, which means the barbell is being lowered from the pulled position
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
