import 'package:Vyayama/resource/theme/theme.dart';
import 'package:Vyayama/screens/home/view_model/workout_detector_view_model.dart';
import 'package:Vyayama/screens/home/workout_detector/base_workout_detector.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkoutProgress extends GetView<WorkoutDetectorViewModel> {
  const WorkoutProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100,
          ),
          Obx(() {
            var progress = controller.workoutProgressStatus.value ==
                    WorkoutProgressStatus.middlePose
                ? 1.0
                : 0.0;
            return AnimatedOpacity(
              opacity:
                  controller.workoutStatus.value != WorkoutStatus.init ? 1 : 0,
              duration: const Duration(seconds: 3),
              child: Column(
                children: [
                  AnimatedContainer(
                    alignment: Alignment.center,
                    duration: const Duration(milliseconds: 200),
                    width: progress == 0.0 ? 10 : 300,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppThemedata.primary,
                      border:
                          Border.all(color: Colors.white), // Added border color
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.repeat,
                        color: AppThemedata.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      AnimatedFlipCounter(
                        prefix: " Reps : ",
                        suffix: " / ${controller.workout.reps.toString()}",
                        duration: const Duration(milliseconds: 500),
                        value: controller.totalJumpingJack.value,
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppThemedata.onSuraface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.fitness_center,
                        color: AppThemedata.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Weight: ${controller.workout.weight} kg',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppThemedata.onSuraface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
