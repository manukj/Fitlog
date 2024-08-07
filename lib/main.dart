import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gainz/app.dart';
import 'package:gainz/firebase_options.dart';
import 'package:gainz/resource/auth/auth_view_model.dart';
import 'package:gainz/resource/firebase/db_service.dart';
import 'package:gainz/screens/home/view_model/record_view_model.dart';
import 'package:get/get.dart';

void main() async {
  await initalise();
  runApp(const App());
}

Future<void> initalise() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var authViewModel = Get.put(AuthViewModel());
  Get.put(DbService(authViewModel));
  Get.put(RecordViewModel());
}
