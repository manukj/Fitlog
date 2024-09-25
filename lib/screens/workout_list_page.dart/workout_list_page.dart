import 'package:Vyayama/common_widget/common_error_view.dart';
import 'package:Vyayama/common_widget/common_loader.dart';
import 'package:Vyayama/common_widget/common_scaffold.dart';
import 'package:Vyayama/common_widget/primary_button.dart';
import 'package:Vyayama/resource/constants/assets_path.dart';
import 'package:Vyayama/resource/firebase/model/workour_records.dart';
import 'package:Vyayama/screens/home/model/workout_list.dart';
import 'package:Vyayama/screens/workout_list_page.dart/view_model/workout_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WorkoutListPage extends GetView<WorkoutListController> {
  const WorkoutListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: const Text("Workout List"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const CommonLoader();
        }

        if (!controller.isLoggedIn.value) {
          return CommonErrorView(
            title: 'Please log in to view your workouts',
            buttonTitle: "Login with Google",
            onButtonPressed: () {
              Get.back();
            },
            lottiePath: AssetsPath.warningAnimation,
            buttonPrefix: const Icon(
              Icons.login,
              color: Color(0xFF0A0A12),
            ),
          );
        }

        if (controller.workoutRecords.isEmpty) {
          return CommonErrorView(
            title: 'No workout records found',
            buttonTitle: "Start Workout",
            onButtonPressed: () {
              Get.back();
            },
            lottiePath: AssetsPath.emptyList,
          );
        }

        return ListView.builder(
          itemCount: controller.workoutRecords.length,
          itemBuilder: (context, index) {
            WorkoutRecord record = controller.workoutRecords[index];
            Workout? workout = WorkoutList.workouts.firstWhereOrNull(
              (w) => w.type.toString() == record.workoutID,
            );

            return workout != null
                ? _buildWorkoutCard(workout, record)
                : const SizedBox.shrink();
          },
        );
      }),
    );
  }

  // Build login button for the user to sign in
  Widget _buildLoginButton(WorkoutListController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              AssetsPath.warningAnimation,
              height: 200,
            ),
            const Text(
              'Please log in to view your workouts',
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              onPressed: controller.login,
              prefix: const Icon(
                Icons.login,
                color: Color(0xFF0A0A12),
              ),
              text: 'Login with Google',
            ),
          ],
        ),
      ),
    );
  }

  // Build each workout card
  Widget _buildWorkoutCard(Workout workout, WorkoutRecord record) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                workout.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Workout Details (Name, Date, Reps)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${record.date}', // Assuming `record.date` is a formatted date string
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Reps: ${record.reps}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Weight: ${record.weight.toStringAsFixed(1)} kg',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
