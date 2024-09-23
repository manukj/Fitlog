import 'package:Vyayama/common_widget/common_error_view.dart';
import 'package:Vyayama/common_widget/common_loader.dart';
import 'package:Vyayama/resource/toast/toast_manager.dart';
import 'package:Vyayama/screens/home/model/workout_list.dart';
import 'package:Vyayama/screens/home/view_model/pose_detector_view_model.dart';
import 'package:Vyayama/screens/home/widget/camera_widget.dart';
import 'package:Vyayama/screens/home/widget/user_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final Workout workout;
  final PoseDetectorViewModel poseViewModel = Get.put(PoseDetectorViewModel());

  HomePage({super.key, required this.workout});

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
              Column(
                children: [
                  UserInfo(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: workout.image,
                        child: Image.asset(
                          workout.image,
                          height: 50,
                          width: 50,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        workout.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
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
