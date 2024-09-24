import 'dart:async';
import 'dart:io';

import 'package:Vyayama/resource/audio_player/audio_player_helper.dart';
import 'package:Vyayama/resource/logger/logger.dart';
import 'package:Vyayama/resource/toast/toast_manager.dart';
import 'package:Vyayama/resource/util/bottom_sheet_util.dart';
import 'package:Vyayama/screens/home/model/workout_list.dart';
import 'package:Vyayama/screens/home/widget/summary_workout_bottom_sheet.dart';
import 'package:Vyayama/screens/home/workout_detector/barbell_row_detector.dart';
import 'package:Vyayama/screens/home/workout_detector/base_workout_detector.dart';
import 'package:Vyayama/screens/home/workout_detector/interface/i_workout_detector.dart';
import 'package:Vyayama/screens/home/workout_detector/interface/i_workout_detector_call_back.dart';
import 'package:Vyayama/screens/home/workout_detector/jumping_jack_detector.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

enum WorkoutStatus { init, starting, started }

class PoseDetectorViewModel extends GetxController
    implements IWorkoutDetectorCallback {
  final AudioPlayerHelper audioPlayerHelper = Get.put(AudioPlayerHelper());

  late Workout workout;
  late List<CameraDescription> cameras;
  IWorkoutDetector? _poseDetector;
  CameraController? controller;
  Future<void>? initializeControllerFuture;
  Rx<CustomPaint?> customPaint = Rx<CustomPaint?>(null);
  Rx<bool> showCountDown = Rx<bool>(false);
  Rx<num> totalJumpingJack = Rx<num>(0);
  Rx<WorkoutStatus> workoutStatus = Rx<WorkoutStatus>(WorkoutStatus.init);
  Rx<String> informationMessage = Rx<String>('');

  init(Workout workout) async {
    this.workout = workout;
    initPoseDetector();
    cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('No camera found');
    } else {
      final firstCamera = cameras.first;
      controller = CameraController(
        firstCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
      initializeControllerFuture = controller?.initialize();
    }
  }

  void initPoseDetector() {
    switch (workout.type) {
      case WorkouTypeEnums.jumpingJacks:
        _poseDetector = JumpingJackDetector(this);
        break;
      case WorkouTypeEnums.barbellRow:
        _poseDetector = BarbellRowDetector(this);
        break;
      case WorkouTypeEnums.benchPress:
        // TODO: Implement BenchPress
        break;
      case WorkouTypeEnums.shoulderPress:
        // TODO: Implement ShoulderPress
        break;
      case WorkouTypeEnums.deadlift:
        // TODO: Implement Deadlift
        break;
      case WorkouTypeEnums.squat:
        // TODO: Implement Squat
        break;
    }
  }

  Future<void> startWorkout() async {
    if (_poseDetector == null) {
      appLogger.error('Pose Detector Service is not initialized');
      ToastManager.showError(
          'Something went wrong, please try different workout');
      return;
    }
    workoutStatus.value = WorkoutStatus.starting;
    await _startCountDown();
    _poseDetector!.resetCount();
    controller!.startImageStream((image) {
      _poseDetector!.detectPose(
        image,
        controller!.description,
        controller!,
      );
    });
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

  @override
  void onClose() {
    controller?.dispose();
    _poseDetector?.dispose();
    audioPlayerHelper.dispose();
    super.onClose();
  }

  @override
  void onPoseStatusChanged(WorkoutProgressStatus status) {
    switch (status) {
      case WorkoutProgressStatus.init:
        informationMessage.value = 'Starting Position';
        break;
      case WorkoutProgressStatus.middlePose:
        informationMessage.value = 'Middle Position';
        break;
      case WorkoutProgressStatus.finalPose:
        informationMessage.value = 'Final Position';
        break;
    }
  }

  @override
  void onPoseDetected(CustomPaint paint) async {
    customPaint.value = paint;
  }

  @override
  void onWorkoutCompleted(int count) {
    totalJumpingJack.value = count;
    audioPlayerHelper.play();
  }

  @override
  void noPersonFound() {
    informationMessage.value = 'No person found';
  }
}
