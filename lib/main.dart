import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gainz/app.dart';
import 'package:gainz/firebase_options.dart';
import 'package:gainz/resource/auth/auth_view_model.dart';
import 'package:get/get.dart';

void main() async {
  initalise();
  runApp(const App());
}

Future<void> initalise() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthViewModel());
}
