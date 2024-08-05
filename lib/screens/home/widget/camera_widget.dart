import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gainz/common_widget/primary_button.dart';
import 'package:gainz/resource/constants/image_path.dart';
import 'package:gainz/screens/home/view_model/camera_view_model.dart';
import 'package:gainz/screens/home/widget/button_widget.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CameraWidget extends GetView<CameraViewModel> {
  const CameraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CameraPreview(
              controller.controller!,
              child: Obx(() {
                return controller.customPaint.value ?? Container();
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            const WorkoutStatusButton(),
          ],
        ),
        _buildCountDownAnimation(),
      ],
    );
  }

  Widget _buildButton() {
    return Row(
      children: [
        PrimaryButton(
          onPressed: () {
            controller.startWorkout();
          },
          child: const Icon(Icons.pause),
        ),
        PrimaryButton(
          onPressed: () {
            controller.startWorkout();
          },
          child: const Icon(Icons.pause),
        )
      ],
    );
    // return Obx(() {
    //   return PrimaryButton(
    //     onPressed: () {
    //       controller.startDetecting();
    //     },
    //     text:
    //         controller.workoutStarted.value ? "Stop Workout" : "Start Workout",
    //   );
    // });
  }

  Widget _buildCountDownAnimation() {
    return Obx(
      () {
        if (controller.showCountDown.value) {
          return Center(
            child: Lottie.asset(
              ImagePath.countDownAnimation,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
