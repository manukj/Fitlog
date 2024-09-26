import 'package:Vyayama/common_widget/common_loader.dart';
import 'package:Vyayama/common_widget/primary_button.dart';
import 'package:Vyayama/resource/constants/assets_path.dart';
import 'package:Vyayama/screens/workout/view_model/record_view_model.dart';
import 'package:Vyayama/screens/workout/widget/record_bottom_sheet/record_bar_chart.dart';
import 'package:flutter/material.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Today's Records ${controller.getTodayRecord()}",
          style: const TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 330,
          child: RepsBarChart(data: controller.records.value),
        ),
      ],
    );
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
          height: 230,
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
