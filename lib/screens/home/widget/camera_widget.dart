import 'package:Vyayama/resource/constants/assets_path.dart';
import 'package:Vyayama/resource/logger/logger.dart';
import 'package:Vyayama/resource/theme/theme.dart';
import 'package:Vyayama/screens/home/view_model/workout_detector_view_model.dart';
import 'package:Vyayama/screens/home/widget/button_widget.dart';
import 'package:Vyayama/screens/home/widget/count_down_and_timer.dart';
import 'package:Vyayama/screens/home/workout_detector/base_workout_detector.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
            appLogger.debug('progress: $progress');
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
