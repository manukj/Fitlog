import 'dart:isolate';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
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

  DetectPoseParam(this.metadata, this.bytes, this.sendPort);
}

class DetectPoseResult {
  final CustomPaint customPaint;
  final List<Pose> poses;

  DetectPoseResult(this.customPaint, this.poses);
}

class PoseDetectorService {
  final IPoseDetectorService _iPoseDetectorService;
  var totalJumpingJacks = 0;
  var previousJumpingJackStatus = JumpingJackStatus.standing;

  PoseDetectorService(this._iPoseDetectorService);

  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(),
  );

  void detectPose(CameraImage image, CameraDescription camera,
      CameraController cameraController) async {
    final inputImage =
        ImageUtil.inputImageFromCameraImage(image, camera, cameraController);
    if (inputImage == null) return;
    inputImage.metadata;
    inputImage.bytes;

    final poses = await _poseDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        CameraLensDirection.back, // might need to change this
      );
      // send using thread
      checkTheStatusOfPoses(poses);
      _iPoseDetectorService.onPoseDetected(CustomPaint(painter: painter));
    }
  }

  // use
  Future<void> detectPoseInIsolate(DetectPoseParam param) async {
    final inputImage = InputImage.fromBytes(
      bytes: param.bytes,
      metadata: param.metadata,
    );
    final poses = await _poseDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        CameraLensDirection.back, // might need to change this
      );
      // send using thread
      final result = DetectPoseResult(CustomPaint(painter: painter), poses);
      param.sendPort.send(result);
    }
  }

  void checkTheStatusOfPoses(List<Pose> poses) async {
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
}
