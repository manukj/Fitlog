import 'package:flutter/material.dart';
import 'package:gainz/common_widget/common_error_view.dart';
import 'package:gainz/common_widget/common_loader.dart';
import 'package:gainz/resource/toast/toast_manager.dart';
import 'package:gainz/screens/home/view_model/pose_detector_view_model.dart';
import 'package:gainz/screens/home/widget/camera_widget.dart';
import 'package:gainz/screens/home/widget/user_info.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final PoseDetectorViewModel poseViewModel = Get.put(PoseDetectorViewModel());

  HomePage({super.key});

  Future<void> _initializeCamera() async {
    await poseViewModel.init();
    return poseViewModel.initializeControllerFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeCamera(),
        builder: (context, snapshot) {
          return Stack(
            children: [
              _buildCameraWidget(snapshot),
              UserInfo(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCameraWidget(AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CommonLoader();
    } else {
      if (snapshot.hasError) {
        ToastManager.showError(
            "Camera Initialization Failed ${snapshot.error.toString()}");
        return const CommonErrorView(
          title: "Camera Initialization Failed",
        );
      } else {
        if (poseViewModel.controller != null) {
          return const CameraWidget();
        } else {
          return const CommonLoader();
        }
      }
    }
  }
}
