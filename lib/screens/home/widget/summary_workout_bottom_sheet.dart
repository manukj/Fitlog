import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:gainz/common_widget/primary_button.dart';
import 'package:gainz/resource/auth/auth_view_model.dart';
import 'package:gainz/resource/constants/assets_path.dart';
import 'package:gainz/resource/toast/toast_manager.dart';
import 'package:gainz/screens/record/record.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SummaryWorkoutBottomSheet extends StatelessWidget {
  final num totalJumpingJack;

  const SummaryWorkoutBottomSheet({
    super.key,
    required this.totalJumpingJack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      width: Get.width,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: totalJumpingJack == 0
          ? _buildNoRepWidget()
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Lottie.asset(
                  AssetsPath.successAnimation,
                  height: 200,
                ),
                AnimatedFlipCounter(
                  value: totalJumpingJack,
                  prefix: "Total Reps : ",
                  textStyle: const TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PrimaryButton(
                  onPressed: () {
                    var authViewModel = Get.find<AuthViewModel>();
                    if (authViewModel.isLoggedIn()) {
                      Get.to(const RecordPage());
                    } else {
                      ToastManager.showSuccess("Please login first");
                      authViewModel.signInWithGoogle();
                    }
                  },
                  text: "Save Progress",
                ),
              ],
            ),
    );
  }

  Widget _buildNoRepWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          "No Reps Detected",
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
        ),
        Lottie.asset(
          AssetsPath.jumpingJackAnimation,
          height: 200,
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          onPressed: () {
            Get.back();
          },
          text: "Try Again",
        ),
      ],
    );
  }
}
