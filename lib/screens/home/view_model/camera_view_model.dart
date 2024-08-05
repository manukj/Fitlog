import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:gainz/screens/home/service/i_pose_detector_service.dart';
import 'package:gainz/screens/home/service/post_detector_service.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

enum WorkoutStatus { init, starting, started, paused, resumed, finished }

class CameraViewModel extends GetxController implements IPoseDetectorService {
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 100));
  late final PoseDetectorService _poseDetectorService;
  Timer? _timer;
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
    _timer?.cancel();
  }

  void resumeWorkout() {
    workoutStatus.value = WorkoutStatus.resumed;
    _startCountDown();
    _detectPoses();
  }

  Future<void> finishWorkout() async {
    controller!.stopImageStream();
    _timer?.cancel();
    Future.delayed(const Duration(seconds: 3), () {
      customPaint.value = null;
      workoutStatus.value = WorkoutStatus.finished;
    });
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
    _poseDetectorService.resetCount();
    controller!.startImageStream((image) {
      _timer = Timer.periodic(const Duration(seconds: 200), (timer) {
        _poseDetectorService.detectPose(
          image,
          controller!.description,
          controller!,
        );
      });
    });
  }

  @override
  void onClose() {
    controller?.dispose();
    _timer?.cancel();
    super.onClose();
  }

  @override
  void noPersonFound() {}

  @override
  void onPoseDetected(CustomPaint customPaint) async {
    _debouncer.call(() {
      this.customPaint.value = customPaint;
    });
  }
}
