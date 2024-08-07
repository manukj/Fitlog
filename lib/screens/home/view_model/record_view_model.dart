import 'package:gainz/resource/firebase/db_service.dart';
import 'package:gainz/resource/firebase/model/reps_record.dart';
import 'package:get/get.dart';

class RecordViewModel extends GetxController {
  final DbService dbService = Get.find<DbService>();

  Rx<List<RepsRecord>> records = Rx<List<RepsRecord>>([]);
  Rx<bool> isLoading = Rx<bool>(false);

  @override
  void onInit() {
    super.onInit();
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    isLoading.value = true;
    // records.value = await dbService.fetchReps();
    isLoading.value = false;
  }
}
