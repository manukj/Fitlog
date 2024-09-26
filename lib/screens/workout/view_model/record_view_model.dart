import 'package:Vyayama/resource/firebase/db_service.dart';
import 'package:Vyayama/resource/firebase/model/workour_records.dart';
import 'package:Vyayama/resource/logger/logger.dart';
import 'package:flutter/material.dart';
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
      await _dbService.saveWorkoutRecord(record);
      fetchRecords();
      isLoading.value = false;
    } catch (e) {
      appLogger.error(e.toString());
      rethrow;
    }
  }

  WorkoutRecord? getTodayRecord(String workoutID, DateTime date) {
    for (final record in records.value) {
      if (record.workoutID == workoutID &&
          DateUtils.isSameDay(record.date, date)) {
        return record;
      }
    }
    return null;
  }
}
