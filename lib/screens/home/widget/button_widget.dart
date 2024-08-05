import 'package:flutter/material.dart';
import 'package:gainz/common_widget/primary_button.dart';
import 'package:gainz/screens/home/view_model/camera_view_model.dart';
import 'package:get/get.dart';

class WorkoutStatusButton extends GetView<PoseDetectionViewModel> {
  const WorkoutStatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.workoutStatus.value == WorkoutStatus.init ||
          controller.workoutStatus.value == WorkoutStatus.starting) {
        return _buildStartButton(controller.workoutStatus.value);
      }

      return _buildPauseAndStopButton(controller.workoutStatus.value);
    });
  }

  Widget _buildStartButton(WorkoutStatus status) {
    return PrimaryButton(
      onPressed: status == WorkoutStatus.starting
          ? null
          : () {
              controller.startWorkout();
            },
      text:
          status == WorkoutStatus.starting ? "Starting....." : "Start Workout",
    );
  }

  Widget _buildPauseAndStopButton(WorkoutStatus status) {
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            showShimmer: false,
            color: Colors.grey[700]!,
            onPressed: () {
              if (status == WorkoutStatus.paused) {
                controller.resumeWorkout();
              } else {
                controller.pauseWorkout();
              }
            },
            child: Icon(
              status == WorkoutStatus.paused ? Icons.play_arrow : Icons.pause,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: PrimaryButton(
            showShimmer: false,
            onPressed: () {
              controller.finishWorkout();
            },
            color: Colors.red,
            child: const Icon(
              Icons.stop,
            ),
          ),
        ),
      ],
    );
  }
}
