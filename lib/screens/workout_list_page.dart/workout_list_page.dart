import 'package:Vyayama/common_widget/common_card.dart';
import 'package:Vyayama/common_widget/common_error_view.dart';
import 'package:Vyayama/common_widget/common_loader.dart';
import 'package:Vyayama/common_widget/common_scaffold.dart';
import 'package:Vyayama/resource/constants/assets_path.dart';
import 'package:Vyayama/resource/firebase/model/workour_records.dart';
import 'package:Vyayama/screens/home/model/workout_list.dart';
import 'package:Vyayama/screens/workout_list_page.dart/view_model/workout_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WorkoutListPage extends StatelessWidget {
  WorkoutListPage({super.key});
  final WorkoutListViewModel controller = Get.put(WorkoutListViewModel());

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
            onButtonPressed: controller.login,
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

  /// Build Workout Card UI
  Widget _buildWorkoutCard(Workout workout, WorkoutRecord record) {
    return CommonCard(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                // Workout Info
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
                        'Date: ${DateFormat('yyyy-MM-dd').format(record.date)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Sets: ${record.sets.length}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    controller.deleteWorkoutRecord(record);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
