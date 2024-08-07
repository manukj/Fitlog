import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gainz/resource/audio_player/audio_player_helper.dart';
import 'package:gainz/resource/util/bottom_sheet_util.dart';
import 'package:gainz/screens/home/service/i_pose_detector_service.dart';
import 'package:gainz/screens/home/service/post_detector_service.dart';
import 'package:gainz/screens/home/widget/summary_workout_bottom_sheet.dart';
import 'package:get/get.dart';

enum WorkoutStatus { init, starting, started }

class PoseDetectorViewModel extends GetxController
    implements IPoseDetectorService {
  final AudioPlayerHelper audioPlayerHelper = Get.put(AudioPlayerHelper());

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
        ResolutionPreset.low,
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
    showAppBottomSheet(
      SummaryWorkoutBottomSheet(totalJumpingJack: totalJumpingJack.value),
      isDismissible: false,
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
    audioPlayerHelper.dispose();
    super.onClose();
  }

  @override
  void onPoseStatus(JumpingJackStatus status) {
    switch (status) {
      case JumpingJackStatus.standing:
        informationMessage.value = 'Standing';
        break;
      case JumpingJackStatus.jumpIn:
        informationMessage.value = 'Jumping in';
        break;
      case JumpingJackStatus.jumpOut:
        informationMessage.value = 'Jumping out';
        break;
    }
  }

  @override
  void onPoseDetected(CustomPaint paint) async {
    customPaint.value = paint;
  }

  @override
  void onJumpingJackCompleted(int count) {
    totalJumpingJack.value = count;
    audioPlayerHelper.play();
  }

  @override
  void noPersonFound() {
    informationMessage.value = 'No person found';
  }
}
