import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:Vyayama/common_widget/primary_button.dart';
import 'package:Vyayama/resource/auth/auth_view_model.dart';
import 'package:Vyayama/resource/constants/assets_path.dart';
import 'package:Vyayama/resource/toast/toast_manager.dart';
import 'package:Vyayama/resource/util/bottom_sheet_util.dart';
import 'package:Vyayama/screens/home/view_model/record_view_model.dart';
import 'package:Vyayama/screens/home/widget/record_bottom_sheet/record_bottom_sheet.dart';
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
    return totalJumpingJack == 0
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
                onPressed: () async {
                  var authViewModel = Get.find<AuthViewModel>();
                  if (!authViewModel.isLoggedIn()) {
                    ToastManager.showSuccess("Please login first");
                    await authViewModel.signInWithGoogle();
                  }
                  Get.find<RecordViewModel>()
                      .saveRecord(totalJumpingJack.toInt());
                  showAppBottomSheet(
                    const RecordsBottomSheet(),
                  );
                },
                text: "Save Progress",
              ),
            ],
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
          AssetsPath.warningAnimation,
          height: 230,
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
