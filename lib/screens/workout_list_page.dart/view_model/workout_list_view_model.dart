import 'package:Vyayama/resource/auth/auth_view_model.dart';
import 'package:Vyayama/resource/firebase/db_service.dart';
import 'package:Vyayama/resource/firebase/model/workour_records.dart';
import 'package:Vyayama/resource/toast/toast_manager.dart';
import 'package:get/get.dart';

class WorkoutListController extends GetxController {
  final DbService _dbService = Get.find<DbService>();
  final AuthViewModel _authViewModel =
      Get.find<AuthViewModel>(); // Get the AuthViewModel instance

  var workoutRecords = <WorkoutRecord>[].obs;
  var isLoading = true.obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoggedIn.value = _authViewModel.isLoggedIn();
    if (isLoggedIn.value) {
      fetchWorkouts();
    } else {
      isLoading.value = false; // Stop loading if user is not logged in
    }
  }

  Future<void> fetchWorkouts() async {
    try {
      isLoading.value = true;
      workoutRecords.value = await _dbService.fetchAllWorkoutRecords();
      isLoading.value = false;
    } catch (e) {
      ToastManager.showError('Failed to fetch workouts');
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    isLoading.value = true;
    bool success = await _authViewModel.signInWithGoogle();
    if (success) {
      isLoggedIn.value = true;
      fetchWorkouts();
    } else {
      isLoading.value = false;
      ToastManager.showError("Login failed");
    }
  }
}
