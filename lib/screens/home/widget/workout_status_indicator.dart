import 'package:Vyayama/resource/theme/theme.dart';
import 'package:Vyayama/screens/home/view_model/workout_detector_view_model.dart';
import 'package:Vyayama/screens/home/workout_detector/base_workout_detector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkoutStatusIndicator extends GetView<WorkoutDetectorViewModel> {
  const WorkoutStatusIndicator({super.key});

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
            return Column(
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
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
