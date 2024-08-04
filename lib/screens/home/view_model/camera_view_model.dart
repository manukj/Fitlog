import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';

class CameraViewModel extends GetxController {
  late List<CameraDescription> cameras;
  Rx<CameraController?> controller = Rx<CameraController?>(null);
  Future<void>? initializeControllerFuture;

  init() async {
    cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('No camera found');
    } else {
      final firstCamera = cameras.first;
      controller.value = CameraController(
        firstCamera,
        ResolutionPreset.high,
        imageFormatGroup:
            Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.nv21,
      );
      initializeControllerFuture = controller.value?.initialize();
    }
  }
}
