import 'package:Vyayama/app.dart';
import 'package:Vyayama/firebase_options.dart';
import 'package:Vyayama/resource/auth/auth_view_model.dart';
import 'package:Vyayama/resource/firebase/db_service.dart';
import 'package:Vyayama/screens/home/view_model/record_view_model.dart';
import 'package:Vyayama/screens/workout_list_page.dart/view_model/workout_list_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
  Get.put(WorkoutListController());
}
