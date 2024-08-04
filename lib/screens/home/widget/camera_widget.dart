import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gainz/common_widget/common_error_view.dart';
import 'package:gainz/common_widget/common_loader.dart';
import 'package:gainz/resource/toast/toast_manager.dart';
import 'package:gainz/screens/home/view_model/camera_view_model.dart';
import 'package:get/get.dart';

class CameraWidget extends GetView<CameraViewModel> {
  const CameraWidget({super.key});
  Future<void> _initializeCamera() async {
    await controller.init();
    return controller.initializeControllerFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeCamera(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CommonLoader();
        } else {
          if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              ToastManager.showError("Camera Initialization Failed");
            });
            return const CommonErrorView(title: "Camera Initialization Failed");
          } else {
            return Obx(() {
              if (controller.controller.value != null) {
                return CameraPreview(
                  controller.controller.value!,
                );
              } else {
                return const CommonLoader();
              }
            });
          }
        }
      },
    );
  }
}
