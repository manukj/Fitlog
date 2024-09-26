import 'package:Vyayama/resource/constants/assets_path.dart';
import 'package:Vyayama/screens/workout/view_model/workout_detector_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CountDownAnimation extends GetView<WorkoutDetectorViewModel> {
  const CountDownAnimation({super.key});

  @override
  Widget build(BuildContext context) {
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
