import 'package:flutter/material.dart';
import 'package:Vyayama/resource/theme/theme.dart';
import 'package:get/get.dart';

Future<void> showAppBottomSheet(Widget newBottomSheetContent,
    {bool isDismissible = true}) {
  // Close all currently open bottom sheets
  while (Get.isBottomSheetOpen ?? false) {
    Get.back();
  }

  // Show the new bottom sheet
 return  Get.bottomSheet(
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
