import 'package:Vyayama/screens/home/view_model/workout_detector_view_model.dart';
import 'package:Vyayama/screens/home/widget/button_widget.dart';
import 'package:Vyayama/screens/home/widget/count_down_and_timer.dart';
import 'package:Vyayama/screens/home/widget/count_down_animation.dart';
import 'package:Vyayama/screens/home/widget/workout_status_indicator.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraWidget extends GetView<WorkoutDetectorViewModel> {
  const CameraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          //calculating the aspect ratio according to the height settings
          var isInitState =
              controller.workoutStatus.value == WorkoutStatus.init;
          var height = (isInitState ? Get.height : Get.height / 2) * 0.6;
          var deviceRatio = Get.width / (height);
          return Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: AnimatedScale(
                duration: const Duration(
                  milliseconds: 1500,
                ),
                scale: (controller.controller!.value.aspectRatio / deviceRatio) *
                    0.5,
                child: CameraPreview(
                  controller.controller!,
                  child: Obx(() {
                    return controller.customPaint.value ?? Container();
                  }),
                ),
              ),
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Obx(() {
                return CountDownAndTimer(
                  start: controller.workoutStatus.value != WorkoutStatus.init,
                );
              }),
              const WorkoutStatusButton(),
            ],
          ),
        ),
        const CountDownAnimation(),
        const WorkoutProgress(),
      ],
    );
  }
}
