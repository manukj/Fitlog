import 'package:flutter/material.dart';
import 'package:gainz/common_widget/common_loader.dart';
import 'package:gainz/screens/home/view_model/record_view_model.dart';
import 'package:get/get.dart';

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
    return Placeholder();
  }
}
