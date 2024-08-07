import 'package:flutter/material.dart';
import 'package:gainz/resource/theme/theme.dart';
import 'package:get/get.dart';

void showAppBottomSheet(Widget newBottomSheetContent,
    {bool isDismissible = true}) {
  // Close all currently open bottom sheets
  while (Get.isBottomSheetOpen ?? false) {
    Get.back();
  }

  // Show the new bottom sheet
  Get.bottomSheet(
    Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: newBottomSheetContent,
    ),
    backgroundColor: AppThemedata.surface,
    isDismissible: isDismissible,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
  );
}
