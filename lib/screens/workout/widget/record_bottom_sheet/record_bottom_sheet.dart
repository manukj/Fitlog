import 'package:Vyayama/common_widget/common_error_view.dart';
import 'package:Vyayama/common_widget/common_loader.dart';
import 'package:Vyayama/resource/constants/assets_path.dart';
import 'package:Vyayama/resource/firebase/model/workour_records.dart';
import 'package:Vyayama/screens/workout/model/workout_list.dart';
import 'package:Vyayama/screens/workout/view_model/record_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecordsBottomSheet extends GetView<RecordViewModel> {
  final WorkoutRecord workoutRecord;
  const RecordsBottomSheet(this.workoutRecord, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const CommonLoader();
      } else if (controller.records.value.isEmpty) {
        return _buildEmptyList();
      } else {
        return WorkoutRecordDisplay(
          workoutRecord: controller.getTodayRecord(
              workoutRecord.workoutID, workoutRecord.date),
        );
      }
    });
  }

  Widget _buildEmptyList() {
    return CommonErrorView(
        title: 'No Records Found',
        buttonTitle: 'Start Workout',
        lottiePath: AssetsPath.emptyList,
        onButtonPressed: () {
          Get.back();
        });
  }
}

class WorkoutRecordDisplay extends StatelessWidget {
  final WorkoutRecord? workoutRecord;

  const WorkoutRecordDisplay({
    super.key,
    required this.workoutRecord,
  });

  @override
  Widget build(BuildContext context) {
    if (workoutRecord == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.fitness_center, size: 28, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  WorkoutList.workouts
                      .firstWhere(
                        (element) =>
                            element.type.toString() == workoutRecord!.workoutID,
                      )
                      .name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 24, color: Color.fromARGB(255, 40, 57, 41)),
                const SizedBox(width: 10),
                Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(workoutRecord!.date)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Sets',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: workoutRecord!.sets.length,
              itemBuilder: (context, index) {
                final SetRecord set = workoutRecord!.sets[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      // Set Icon
                      const Icon(Icons.sports, size: 24, color: Colors.orange),
                      const SizedBox(width: 10),
                      Text(
                        'Set ${index + 1}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Reps Information
                      const Icon(Icons.repeat, size: 24, color: Colors.purple),
                      const SizedBox(width: 5),
                      Text(
                        '${set.reps} reps',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 20),
                      // Weight Information
                      const Icon(Icons.fitness_center,
                          size: 24, color: Colors.teal),
                      const SizedBox(width: 5),
                      Text(
                        '${set.weight.toStringAsFixed(1)} kg',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
