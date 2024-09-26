import 'package:Vyayama/resource/logger/logger.dart';
import 'package:Vyayama/resource/painter/pose_painter.dart';
import 'package:Vyayama/resource/util/image_util.dart';
import 'package:Vyayama/screens/workout/workout_detector/interface/i_workout_detector.dart';
import 'package:Vyayama/screens/workout/workout_detector/interface/i_workout_detector_call_back.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

enum WorkoutProgressStatus {
  init,
  middlePose,
  finalPose,
}

abstract class BaseWorkoutDetector extends IWorkoutDetector {
  final poseDetector = PoseDetector(options: PoseDetectorOptions());
  final IWorkoutDetectorCallback _callback;
  bool _canProcess = true;
  bool _isBusy = false;
  var totalReps = 0;

  BaseWorkoutDetector(this._callback);

  @override
  void dispose() {
    poseDetector.close();
  }

  @override
  Future<void> detectPose(CameraImage image, CameraDescription camera,
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

  @override
  void resetCount() {
    totalReps = 0;
    _canProcess = true;
    _isBusy = false;
    appLogger.debug('Reps Count Reset to $totalReps');
  }
}
