import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gainz/resource/constants/assets_path.dart';
import 'package:gainz/screens/home/view_model/pose_detector_view_model.dart';
import 'package:gainz/screens/home/widget/button_widget.dart';
import 'package:gainz/screens/home/widget/count_down_and_timer.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CameraWidget extends GetView<PoseDetectorViewModel> {
  const CameraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          var isInitState =
              controller.workoutStatus.value == WorkoutStatus.init;
          return Align(
            alignment: Alignment.center,
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 1500,
              ),
              height: isInitState ? Get.height : Get.height / 2,
              width: Get.width,
              child: AspectRatio(
                aspectRatio: 1,
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
        _buildCountDownAnimation(),
        _buildInformationMessage(),
      ],
    );
  }

  Widget _buildInformationMessage() {
    return Obx(
      () {
        if (controller.informationMessage.value.isNotEmpty) {
          return Positioned(
            top: 80,
            child: Container(
              height: 110,
              width: Get.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                controller.informationMessage.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildCountDownAnimation() {
    return Obx(
      () {
        if (controller.showCountDown.value) {
          return Center(
            child: Lottie.asset(
              AssetsPath.countDownAnimation,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
