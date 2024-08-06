import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:gainz/screens/home/service/i_pose_detector_service.dart';
import 'package:gainz/screens/home/service/post_detector_service.dart';
import 'package:gainz/screens/home/widget/calculating_workout_bottom_sheet.dart';
import 'package:get/get.dart';

enum WorkoutStatus { init, starting, started }

class PoseDetectorViewModel extends GetxController
    implements IPoseDetectorService {
  late final PoseDetectorService _poseDetectorService;
  late List<CameraDescription> cameras;
  CameraController? controller;
  Future<void>? initializeControllerFuture;
  Rx<CustomPaint?> customPaint = Rx<CustomPaint?>(null);
  Rx<bool> showCountDown = Rx<bool>(false);
  Rx<num> totalJumpingJack = Rx<num>(0);
  Rx<WorkoutStatus> workoutStatus = Rx<WorkoutStatus>(WorkoutStatus.init);

  PoseDetectorViewModel() {
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

  Future<void> finishWorkout() async {
    controller!.stopImageStream();
    workoutStatus.value = WorkoutStatus.init;
    Get.bottomSheet(
      const CalculatingWorkoutBottomSheet(),
      isDismissible: false,
      enableDrag: true,
    );
    Future.delayed(const Duration(seconds: 1), () {
      customPaint.value = null;
    });
  }

  Future<void> _startCountDown() async {
    showCountDown.value = true;
    await Future.delayed(const Duration(seconds: 5), () {
      showCountDown.value = false;
      workoutStatus.value = WorkoutStatus.started;
    });
  }

  void _detectPoses() {
    _poseDetectorService.resetCount();
    controller!.startImageStream((image) {
      _poseDetectorService.detectPose(
        image,
        controller!.description,
        controller!,
      );
    });
  }

  @override
  void onClose() {
    controller?.dispose();
    _poseDetectorService.dispose();
    super.onClose();
  }

  @override
  void noPersonFound() {}

  @override
  void onPoseDetected(int totalCount, CustomPaint paint) async {
    totalJumpingJack.value = totalCount;
    this.customPaint.value = paint;
  }
}
