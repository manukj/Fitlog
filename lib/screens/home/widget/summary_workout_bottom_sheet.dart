import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:gainz/common_widget/primary_button.dart';
import 'package:gainz/resource/constants/image_path.dart';
import 'package:gainz/resource/theme/theme.dart';
import 'package:gainz/screens/home/view_model/pose_detector_view_model.dart';
import 'package:gainz/screens/record/record.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SummaryWorkoutBottomSheet extends GetView<PoseDetectorViewModel> {
  const SummaryWorkoutBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      width: Get.width,
      decoration: const BoxDecoration(
        color: AppThemedata.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Lottie.asset(
            ImagePath.successAnimation,
            height: 200,
          ),
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
          PrimaryButton(
            onPressed: () {
              Get.to(const RecordPage());
            },
            text: "Save Progress",
          ),
        ],
      ),
    );
  }
}
