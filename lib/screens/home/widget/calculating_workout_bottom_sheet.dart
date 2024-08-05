import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:gainz/resource/constants/image_path.dart';
import 'package:gainz/resource/theme/theme.dart';
import 'package:gainz/screens/home/view_model/pose_detector_view_model.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CalculatingWorkoutBottomSheet extends GetView<PoseDetectorViewModel> {
  const CalculatingWorkoutBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppThemedata.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildHeader(),
          Obx(
            () {
              return AnimatedFlipCounter(
                value: controller.totalJumpingJack.value,
                prefix: "Total Reps : ",
                textStyle: const TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  _buildHeader() {
    return Obx(() {
      return (controller.calculatingTotalWorkout.value)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Calculating total workout,\n Please wait....',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Lottie.asset(ImagePath.jumpingJackAnimation, height: 250),
                const SizedBox(height: 20),
              ],
            )
          : Lottie.asset(ImagePath.successAnimation, height: 250);
    });
  }
}
