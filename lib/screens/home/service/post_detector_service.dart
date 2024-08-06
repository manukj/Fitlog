import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gainz/resource/logger/logger.dart';
import 'package:gainz/resource/painter/pose_painter.dart';
import 'package:gainz/resource/util/image_util.dart';
import 'package:gainz/screens/home/service/i_pose_detector_service.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

enum JumpingJackStatus {
  standing,
  jumpOut, // when legs are spread and hands are above
  jumpIn, // when you bring your legs together and lowering the arm
}

class DetectPoseParam {
  final InputImageMetadata metadata;
  final Uint8List bytes;
  final SendPort sendPort;
  final RootIsolateToken token;

  DetectPoseParam(this.metadata, this.bytes, this.sendPort, this.token);
}

class DetectPoseResult {
  final List<Pose> poses;

  DetectPoseResult(this.poses);
}

extension PoseSerialization on Pose {
  Map<String, dynamic> toJson() {
    return {
      'landmarks': landmarks.map((type, landmark) =>
          MapEntry(type.index.toString(), landmark.toJson())),
    };
  }

  static Pose fromJson(Map<String, dynamic> json) {
    final landmarks = (json['landmarks'] as Map<String, dynamic>).map(
      (type, landmarkJson) => MapEntry(
        PoseLandmarkType.values[int.parse(type)],
        PoseLandmark.fromJson(landmarkJson),
      ),
    );
    return Pose(landmarks: landmarks);
  }
}

extension PoseLandmarkSerialization on PoseLandmark {
  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'x': x,
      'y': y,
      'z': z,
      'likelihood': likelihood,
    };
  }

  static PoseLandmark fromJson(Map<String, dynamic> json) {
    return PoseLandmark(
      type: PoseLandmarkType.values[json['type'].toInt()],
      x: json['x'],
      y: json['y'],
      z: json['z'],
      likelihood: json['likelihood'] ?? 0.0,
    );
  }
}

class PoseDetectorService {
  final poseDetector = PoseDetector(options: PoseDetectorOptions());
  final IPoseDetectorService _iPoseDetectorService;
  var totalJumpingJacks = 0;
  bool _canProcess = true;
  bool _isBusy = false;
  var previousJumpingJackStatus = JumpingJackStatus.standing;

  PoseDetectorService(this._iPoseDetectorService);

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
    _iPoseDetectorService.onPoseDetected(totalJumpingJacks);
    final painter = PosePainter(
      poses,
      inputImage.metadata!.size,
      inputImage.metadata!.rotation,
      CameraLensDirection.back,
    );
    _iPoseDetectorService.onPoseDetectionPain(CustomPaint(
      painter: painter,
    ));
    _isBusy = false;
  }

  void checkTheStatusOfPoses(List<Pose> poses) {
    JumpingJackStatus? currentJumpingJackStatus;
    if (poses.isEmpty) {
      appLogger.debug('No Person Found');
      return _iPoseDetectorService.noPersonFound();
    }
    final Pose pose = poses.first;

    final PoseLandmark leftShoulder =
        pose.landmarks[PoseLandmarkType.leftShoulder]!;
    final PoseLandmark rightShoulder =
        pose.landmarks[PoseLandmarkType.rightShoulder]!;
    final PoseLandmark leftHip = pose.landmarks[PoseLandmarkType.leftHip]!;
    final PoseLandmark rightHip = pose.landmarks[PoseLandmarkType.rightHip]!;
    final PoseLandmark leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle]!;
    final PoseLandmark rightAnkle =
        pose.landmarks[PoseLandmarkType.rightAnkle]!;
    final PoseLandmark leftWrist = pose.landmarks[PoseLandmarkType.leftWrist]!;
    final PoseLandmark rightWrist =
        pose.landmarks[PoseLandmarkType.rightWrist]!;

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
      currentJumpingJackStatus = JumpingJackStatus.jumpOut;
    } else if (ankleDistance < shoulderDistance * 1.2 && !handsAboveShoulders) {
      appLogger.debug('Jumping Jacks: Jump In');
      currentJumpingJackStatus = JumpingJackStatus.jumpIn;
    }

    appLogger.debug(
        'Jumping Jacks: previous $previousJumpingJackStatus current $currentJumpingJackStatus ');

    if (previousJumpingJackStatus == JumpingJackStatus.jumpOut &&
        currentJumpingJackStatus == JumpingJackStatus.jumpIn) {
      totalJumpingJacks++;
      appLogger.debug('Total Jumping Jacks: $totalJumpingJacks');
    }

    if (currentJumpingJackStatus != null) {
      previousJumpingJackStatus = currentJumpingJackStatus;
    }
  }

  void resetCount() {
    totalJumpingJacks = 0;
    appLogger.debug('Total Jumping Jacks: reset $totalJumpingJacks');
  }

  void dispose() {
    _canProcess = false;
    poseDetector.close();
  }
}
