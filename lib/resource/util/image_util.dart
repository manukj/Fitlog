import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class ImageUtil {
  static final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  static Future<InputImage> inputImageFromCameraImage(CameraImage image,
      CameraDescription camera, CameraController controller) async {
    final ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(_processImage, {
      'sendPort': receivePort.sendPort,
      'image': image,
      'camera': camera,
      'deviceOrientation': controller.value.deviceOrientation,
    });

    return await receivePort.first as InputImage;
  }

  static void _processImage(Map<String, dynamic> params) {
    final SendPort sendPort = params['sendPort'];
    final CameraImage image = params['image'];
    final CameraDescription camera = params['camera'];
    final DeviceOrientation deviceOrientation = params['deviceOrientation'];

    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[deviceOrientation];
      if (rotationCompensation == null) {
        sendPort.send(null);
        return;
      }
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) {
      sendPort.send(null);
      return;
    }

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      sendPort.send(null);
      return;
    }

    if (image.planes.length != 1) {
      sendPort.send(null);
      return;
    }
    final plane = image.planes.first;

    final inputImage = InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );

    sendPort.send(inputImage);
  }
}
