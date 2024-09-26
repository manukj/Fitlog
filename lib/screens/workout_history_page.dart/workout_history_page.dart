import 'package:Vyayama/common_widget/common_card.dart';
import 'package:Vyayama/common_widget/common_error_view.dart';
import 'package:Vyayama/common_widget/common_loader.dart';
import 'package:Vyayama/common_widget/common_scaffold.dart';
import 'package:Vyayama/resource/constants/assets_path.dart';
import 'package:Vyayama/resource/firebase/model/workour_records.dart';
import 'package:Vyayama/resource/util/bottom_sheet_util.dart';
import 'package:Vyayama/screens/home/model/workout_list.dart';
import 'package:Vyayama/screens/workout_history_page.dart/view_model/workout_list_view_model.dart';
import 'package:Vyayama/screens/workout_history_page.dart/widget/edit_set_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WorkoutHistoryPage extends StatelessWidget {
  WorkoutHistoryPage({super.key});
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

  Widget _buildWorkoutCard(Workout workout, WorkoutRecord record) {
    return CommonCard(
      onPressed: () {
        showAppBottomSheet(EditSetsBottomSheet(
          sets: record.sets,
          onSave: () {
            // controller.updateWorkoutRecord(record);
            Get.back();
          },
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Workout Image
                Image.asset(
                  workout.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
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
