import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vyayama/resource/auth/auth_view_model.dart';
import 'package:Vyayama/resource/firebase/model/reps_record.dart';
import 'package:Vyayama/resource/util/date_util.dart';
import 'package:get/get.dart';

class DbService {
  final AuthViewModel authViewModel;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DbService(this.authViewModel);

  String get userId => authViewModel.user?.uid ?? '';

  Future<void> _addNewRep(RepsRecord rep) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('reps')
          .add(rep.toMap());
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<List<RepsRecord>> fetchReps() async {
    List<RepsRecord> repsList = [];
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)  
          .collection('reps')
          .orderBy('date', descending: false)
          .limit(14)
          .get();
      repsList = querySnapshot.docs
          .map((doc) => RepsRecord.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
    return repsList;
  }

  Future<void> saveRecord(int newCount) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('reps')
          .where('date', isEqualTo: Timestamp.fromDate(DateUtil.getToday()))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        int previousCount = doc['count'];
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('reps')
            .doc(doc.id)
            .update({
          'count': previousCount + newCount,
        });
      } else {
        _addNewRep(
          RepsRecord(date: DateUtil.getToday(), count: newCount),
        );
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
