import 'package:flutter/material.dart';
import 'package:gainz/common_widget/primary_button.dart';
import 'package:gainz/resource/theme/theme.dart';
import 'package:gainz/screens/home/view_model/pose_detector_view_model.dart';
import 'package:get/get.dart';

class WorkoutStatusButton extends GetView<PoseDetectorViewModel> {
  const WorkoutStatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.workoutStatus.value == WorkoutStatus.init ||
          controller.workoutStatus.value == WorkoutStatus.starting) {
        return _buildStartButton(controller.workoutStatus.value);
      } else {
        return _buildStopButton(controller.workoutStatus.value);
      }
    });
  }

  Widget _buildStartButton(WorkoutStatus status) {
    return PrimaryButton(
      onPressed: status == WorkoutStatus.starting
          ? null
          : () {
              controller.startWorkout();
            },
      prefix: const Icon(
        Icons.play_arrow,
        color: AppThemedata.surface,
      ),
      text:
          status == WorkoutStatus.starting ? "Starting....." : "Start Workout",
    );
  }

  Widget _buildStopButton(WorkoutStatus status) {
    return Builder(builder: (context) {
      return PrimaryButton(
        showShimmer: false,
        onPressed: () {
          controller.finishWorkout();
        },
        prefix: const Icon(
          Icons.stop,
        ),
        color: Colors.red,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        text: "Stop Workout",
      );
    });
  }
}
