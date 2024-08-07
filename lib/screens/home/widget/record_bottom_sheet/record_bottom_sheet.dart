import 'package:flutter/material.dart';
import 'package:gainz/common_widget/common_loader.dart';
import 'package:gainz/common_widget/primary_button.dart';
import 'package:gainz/resource/constants/assets_path.dart';
import 'package:gainz/screens/home/view_model/record_view_model.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class RecordsBottomSheet extends GetView<RecordViewModel> {
  const RecordsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const CommonLoader();
      } else if (controller.records.value.isEmpty) {
        return _buildEmptyList();
      } else {
        return _buildRecordsList();
      }
    });
  }

  Widget _buildRecordsList() {
    return Placeholder();
  }

  Widget _buildEmptyList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          "No Records Found",
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
        ),
        Lottie.asset(
          AssetsPath.emptyList,
          height: 300,
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          onPressed: () {
            Get.back();
          },
          text: "Start Workout",
        ),
      ],
    );
  }
}
