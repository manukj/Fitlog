import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

enum WorkoutStatus { init, starting, started, paused, resumed, finished }

class CameraViewModel extends GetxController {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  final _cameraLensDirection = CameraLensDirection.back;

  late List<CameraDescription> cameras;
  CameraController? controller;
  Future<void>? initializeControllerFuture;
  Rx<CustomPaint?> customPaint = Rx<CustomPaint?>(null);
  Rx<bool> showCountDown = Rx<bool>(false);
  Rx<WorkoutStatus> workoutStatus = Rx<WorkoutStatus>(WorkoutStatus.init);

  init() async {
    cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('No camera found');
    } else {
      final firstCamera = cameras.first;
      controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
      initializeControllerFuture = controller?.initialize();
    }
  }

  Future<void> startWorkout() async {
    workoutStatus.value = WorkoutStatus.starting;
    await _startCountDown();
    // controller!.startImageStream((image) async {
    //   final inputImage = ImageUtil.inputImageFromCameraImage(
    //       image, cameras.first, controller!);
    //   if (inputImage == null) return;
    //   final poses = await _poseDetector.processImage(inputImage);
    //   if (inputImage.metadata?.size != null &&
    //       inputImage.metadata?.rotation != null) {
    //     final painter = PosePainter(
    //       poses,
    //       inputImage.metadata!.size,
    //       inputImage.metadata!.rotation,
    //       _cameraLensDirection,
    //     );
    //     customPaint.value = CustomPaint(painter: painter);
    //   }
    // });
  }

  Future<void> pauseWorkout() async {
    workoutStatus.value = WorkoutStatus.paused;
    // controller!.stopImageStream();
    // customPaint.value = null;
  }

  Future<void> finishWorkout() async {
    workoutStatus.value = WorkoutStatus.finished;
    // controller!.stopImageStream();
    // customPaint.value = null;
  }

  Future<void> restartDetecting() async {
    workoutStatus.value = WorkoutStatus.init;
  }

  void resumeWorkout() {
    workoutStatus.value = WorkoutStatus.resumed;
    _startCountDown();
  }

  Future<void> _startCountDown() async {
    showCountDown.value = true;
    await Future.delayed(const Duration(seconds: 5), () {
      showCountDown.value = false;
      workoutStatus.value = WorkoutStatus.started;
    });
  }

  @override
  void onClose() {
    controller?.dispose();
    super.onClose();
  }
}
