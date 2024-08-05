import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:gainz/resource/painter/pose_painter.dart';
import 'package:gainz/resource/util/image_util.dart';
import 'package:gainz/screens/home/service/i_pose_detector_service.dart';
import 'package:gainz/screens/home/service/post_detector_service.dart';
import 'package:get/get.dart';

enum WorkoutStatus { init, starting, started, paused, resumed, finished }

class CameraViewModel extends GetxController implements IPoseDetectorService {
  late final PoseDetectorService _poseDetectorService;
  final _cameraLensDirection = CameraLensDirection.back;

  late List<CameraDescription> cameras;
  CameraController? controller;
  Future<void>? initializeControllerFuture;
  Rx<CustomPaint?> customPaint = Rx<CustomPaint?>(null);
  Rx<bool> showCountDown = Rx<bool>(false);
  Rx<WorkoutStatus> workoutStatus = Rx<WorkoutStatus>(WorkoutStatus.init);

  CameraViewModel() {
    _poseDetectorService = PoseDetectorService(this);
  }

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
    _detectPoses();
  }

  Future<void> pauseWorkout() async {
    await controller!.stopImageStream();
    customPaint.value = const CustomPaint();
    workoutStatus.value = WorkoutStatus.paused;
  }

  void resumeWorkout() {
    workoutStatus.value = WorkoutStatus.resumed;
    _startCountDown();
    _detectPoses();
  }

  Future<void> finishWorkout() async {
    workoutStatus.value = WorkoutStatus.finished;
    customPaint.value = const CustomPaint();
    controller!.stopImageStream();
  }

  Future<void> restartDetecting() async {
    workoutStatus.value = WorkoutStatus.init;
  }

  Future<void> _startCountDown() async {
    showCountDown.value = true;
    await Future.delayed(const Duration(seconds: 5), () {
      showCountDown.value = false;
      workoutStatus.value = WorkoutStatus.started;
    });
  }

  void _detectPoses() {
    controller!.startImageStream((image) async {
      final inputImage = ImageUtil.inputImageFromCameraImage(
          image, cameras.first, controller!);
      if (inputImage == null) return;
      final poses = await _poseDetectorService.detectPose(inputImage);

      if (inputImage.metadata?.size != null &&
          inputImage.metadata?.rotation != null) {
        final painter = PosePainter(
          poses,
          inputImage.metadata!.size,
          inputImage.metadata!.rotation,
          _cameraLensDirection,
        );
        customPaint.value = CustomPaint(painter: painter);
      }
    });
  }

  @override
  void onClose() {
    controller?.dispose();
    super.onClose();
  }

  @override
  void noPersonFound() {
    
  }
}
