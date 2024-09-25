import 'package:Vyayama/resource/firebase/db_service.dart';
import 'package:Vyayama/resource/firebase/model/workour_records.dart';
import 'package:Vyayama/resource/logger/logger.dart';
import 'package:get/get.dart';

class RecordViewModel extends GetxController {
  final DbService _dbService = Get.find<DbService>();

  Rx<List<WorkoutRecord>> records = Rx<List<WorkoutRecord>>([]);
  Rx<bool> isLoading = Rx<bool>(false);

  Future<void> fetchRecords() async {
    isLoading.value = true;
    records.value = await _dbService.fetchAllWorkoutRecords();
    isLoading.value = false;
  }

  Future<void> saveRecord(WorkoutRecord record) async {
    try {
      isLoading.value = true;
      await _dbService.saveWorkoutRecord(
        record.workoutID,
        record.reps,
        record.weight,
      );
      fetchRecords();
      isLoading.value = false;
    } catch (e) {
      appLogger.error(e.toString());
      rethrow;
    }
  }

  int? getTodayRecord() {
    // final today = DateTime.now();
    // final record = records.value.firstWhere(
    //   (element) => element.date.day == today.day,
    //   orElse: () => RepsRecord(date: today, count: 0),
    // );
    // return record.count;
  }
}
