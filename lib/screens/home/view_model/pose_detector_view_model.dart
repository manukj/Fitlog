import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:gainz/screens/home/service/i_pose_detector_service.dart';
import 'package:gainz/screens/home/service/post_detector_service.dart';
import 'package:gainz/screens/home/widget/summary_workout_bottom_sheet.dart';
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
  Rx<String> informationMessage = Rx<String>('');

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
      SummaryWorkoutBottomSheet(totalJumpingJack: totalJumpingJack.value),
      isDismissible: false,
      enableDrag: true,
    );
    Future.delayed(const Duration(seconds: 1), () {
      customPaint.value = null;
      informationMessage.value = '';
      totalJumpingJack.value = 0;
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
  void noPersonFound() {
    informationMessage.value = 'No person found';
  }

  @override
  void onJumpingUp() {
    informationMessage.value = 'Jumping up';
  }

  @override
  void onJumpingDown() {
    informationMessage.value = 'Jumping down';
  }

  @override
  void onPoseDetected(int totalCount, CustomPaint paint) async {
    totalJumpingJack.value = totalCount;
    customPaint.value = paint;
  }
}
