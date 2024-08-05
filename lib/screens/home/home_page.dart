import 'package:flutter/material.dart';
import 'package:gainz/common_widget/common_error_view.dart';
import 'package:gainz/common_widget/common_loader.dart';
import 'package:gainz/resource/toast/toast_manager.dart';
import 'package:gainz/screens/home/view_model/pose_detector_view_model.dart';
import 'package:gainz/screens/home/widget/camera_widget.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final PoseDetectorViewModel controller = Get.put(PoseDetectorViewModel());

  HomePage({super.key});

  Future<void> _initializeCamera() async {
    await controller.init();
    return controller.initializeControllerFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeCamera(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CommonLoader();
          } else {
            if (snapshot.hasError) {
              _showErrorToast(snapshot.error.toString());
              return const CommonErrorView(
                title: "Camera Initialization Failed",
              );
            } else {
              if (controller.controller != null) {
                return const CameraWidget();
              } else {
                return const CommonLoader();
              }
            }
          }
        },
      ),
    );
  }

  void _showErrorToast(String string) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ToastManager.showError("Camera Initialization Failed $string");
    });
  }
}
