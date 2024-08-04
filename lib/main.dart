import 'package:flutter/material.dart';
import 'package:gainz/app.dart';
import 'package:gainz/screens/home/view_model/camera_view_model.dart';
import 'package:get/get.dart';

void main() async {
  initalise();
  runApp(const App());
}

Future<void> initalise() async {
  Get.put(CameraViewModel());
}
