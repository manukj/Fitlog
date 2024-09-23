import 'package:Vyayama/resource/logger/logger.dart';
import 'package:Vyayama/resource/painter/pose_painter.dart';
import 'package:Vyayama/resource/util/image_util.dart';
import 'package:Vyayama/screens/home/service/base_pose_detector_service.dart';
import 'package:Vyayama/screens/home/service/interface/i_pose_detector_call_back.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

enum WorkoutProgressStatus {
  standing,
  jumpOut,
  jumpIn,
  init,
  inProgress,
  completed,
}

class JumpingJackDetectorService extends BasePoseDetectorService {
  final IPoseDetectorCallback _callback;
  WorkoutProgressStatus? _previousProgressStatus = WorkoutProgressStatus.init;

  JumpingJackDetectorService(this._callback) : super(_callback);

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
      currentJumpingJackStatus = WorkoutProgressStatus.jumpOut;
    } else if (ankleDistance < shoulderDistance * 1.2 && !handsAboveShoulders) {
      appLogger.debug('Jumping Jacks: Jump In');
      // The first status is detected as Jump In, that means the person is still at the starting position
      if (_previousProgressStatus == null ||
          _previousProgressStatus == WorkoutProgressStatus.standing) {
        currentJumpingJackStatus = WorkoutProgressStatus.standing;
      } else {
        currentJumpingJackStatus = WorkoutProgressStatus.jumpIn;
      }
    }

    appLogger.debug(
        'Jumping Jacks: previous $_previousProgressStatus current $currentJumpingJackStatus');

    if (_previousProgressStatus == WorkoutProgressStatus.jumpOut &&
        currentJumpingJackStatus == WorkoutProgressStatus.jumpIn) {
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

class PoseDetectorService {
  final poseDetector = PoseDetector(options: PoseDetectorOptions());
  final IPoseDetectorCallback _callback;
  var totalReps = 0;
  bool _canProcess = true;
  bool _isBusy = false;
  WorkoutProgressStatus? previousJumpingJackStatus;

  PoseDetectorService(this._callback);

  void detectPose(CameraImage image, CameraDescription camera,
      CameraController cameraController) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    var inputImage = await ImageUtil.inputImageFromCameraImage(
        image, camera, cameraController);
    if (inputImage == null ||
        inputImage.metadata == null && inputImage.bytes == null) return;

    final poses = await poseDetector.processImage(inputImage);
    checkTheStatusOfPoses(poses);
    final painter = PosePainter(
      poses,
      inputImage.metadata!.size,
      inputImage.metadata!.rotation,
      CameraLensDirection.back,
    );
    _callback.onPoseDetected(CustomPaint(
      painter: painter,
    ));

    _isBusy = false;
  }

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
      currentJumpingJackStatus = WorkoutProgressStatus.jumpOut;
    } else if (ankleDistance < shoulderDistance * 1.2 && !handsAboveShoulders) {
      appLogger.debug('Jumping Jacks: Jump In');
      // The first status is detected as Jump In, that means the person is still at the starting position
      if (previousJumpingJackStatus == null ||
          previousJumpingJackStatus == WorkoutProgressStatus.standing) {
        currentJumpingJackStatus = WorkoutProgressStatus.standing;
      } else {
        currentJumpingJackStatus = WorkoutProgressStatus.jumpIn;
      }
    }

    appLogger.debug(
        'Jumping Jacks: previous $previousJumpingJackStatus current $currentJumpingJackStatus');

    if (previousJumpingJackStatus == WorkoutProgressStatus.jumpOut &&
        currentJumpingJackStatus == WorkoutProgressStatus.jumpIn) {
      totalReps++;
      _callback.onWorkoutCompleted(totalReps);
      appLogger.debug('Total Jumping Jacks: $totalReps');
    }

    if (currentJumpingJackStatus != null) {
      _callback.onPoseStatusChanged(currentJumpingJackStatus);
      previousJumpingJackStatus = currentJumpingJackStatus;
    }
  }

  void resetCount() {
    totalReps = 0;
    previousJumpingJackStatus = null;
    _canProcess = true;
    _isBusy = false;
    appLogger.debug('Total Jumping Jacks: reset $totalReps');
  }

  void dispose() {
    _canProcess = false;
    poseDetector.close();
  }
}
