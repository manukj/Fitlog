import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

class ToastManager {
  static void showError(String message,
      {Duration duration = const Duration(seconds: 5)}) {
    toastification.show(
      context: Get.context,
      title: Text(message),
      type: ToastificationType.error,
      autoCloseDuration: duration,
      style: ToastificationStyle.fillColored,
      alignment: Alignment.bottomCenter,
    );
  }

  static void showSuccess(String message,
      {Duration duration = const Duration(seconds: 5)}) {
    toastification.show(
      context: Get.context,
      title: Text(message),
      type: ToastificationType.success,
      autoCloseDuration: duration,
      style: ToastificationStyle.fillColored,
      alignment: Alignment.bottomCenter,
    );
  }
}
