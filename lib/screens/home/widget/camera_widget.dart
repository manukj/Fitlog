import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gainz/common_widget/primary_button.dart';
import 'package:gainz/screens/home/view_model/camera_view_model.dart';
import 'package:get/get.dart';

class CameraWidget extends GetView<CameraViewModel> {
  const CameraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CameraPreview(
          controller.controller!,
          child: Obx(() {
            return controller.customPaint.value ?? Container();
          }),
        ),
        PrimaryButton(
          onPressed: () {
            controller.startDetecting();
          },
          text: "Start workout",
        ),
      ],
    );
  }
}
