import 'package:Vyayama/resource/auth/auth_view_model.dart';
import 'package:Vyayama/resource/firebase/model/workour_records.dart'; // Assuming you have updated model with SetRecord
import 'package:Vyayama/resource/logger/logger.dart';
import 'package:Vyayama/resource/toast/toast_manager.dart';
import 'package:Vyayama/resource/util/date_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DbService {
  final AuthViewModel authViewModel;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DbService(this.authViewModel);

  String get userId => authViewModel.user?.uid ?? '';

  Future<void> saveWorkoutRecord(WorkoutRecord record) async {
    var workoutID = record.workoutID;
    var sets = record.sets;
    try {
      DocumentReference workoutRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(workoutID);

      DocumentSnapshot workoutDoc = await workoutRef.get();
      if (!workoutDoc.exists) {
        await workoutRef.set({
          'workoutID': workoutID,
          'createdAt': FieldValue.serverTimestamp(),
        });
        appLogger.log('Created workout document for workoutID: $workoutID');
      }

      QuerySnapshot querySnapshot = await workoutRef
          .collection('records')
          .where('date', isEqualTo: Timestamp.fromDate(DateUtil.getToday()))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;

        List<dynamic> previousSets = doc['sets'] as List<dynamic>;

        List<SetRecord> previousSetRecords = previousSets.map((set) {
          return SetRecord.fromMap(set as Map<String, dynamic>);
        }).toList();

        previousSetRecords.addAll(sets);

        await workoutRef.collection('records').doc(doc.id).update({
          'sets': previousSetRecords.map((set) => set.toMap()).toList(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await workoutRef.collection('records').add({
          'date': Timestamp.fromDate(DateUtil.getToday()),
          'sets': sets.map((set) => set.toMap()).toList(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      ToastManager.showError('Error saving workout record: $e');
    }
  }

  Future<List<WorkoutRecord>> fetchAllWorkoutRecords() async {
    List<WorkoutRecord> allWorkoutRecords = [];
    try {
      QuerySnapshot workoutSnapshots = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .get();

      List<String> workoutIDs =
          workoutSnapshots.docs.map((doc) => doc.id).toList();

      for (String workoutID in workoutIDs) {
        DocumentReference workoutRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('workouts')
            .doc(workoutID);

        DocumentSnapshot workoutDoc = await workoutRef.get();
        if (workoutDoc.exists) {
          QuerySnapshot recordSnapshots = await workoutRef
              .collection('records')
              .orderBy('date', descending: false)
              .get();

          List<WorkoutRecord> workoutRecords = recordSnapshots.docs.map((doc) {
            return WorkoutRecord.fromMap(
                workoutID, doc.data() as Map<String, dynamic>);
          }).toList();

          allWorkoutRecords.addAll(workoutRecords);
        }
      }
    } catch (e) {
      ToastManager.showError('Error fetching workout records: $e');
    }
    return allWorkoutRecords;
  }

  Future<void> deleteWorkout(String workoutID, DateTime date) async {
    try {
      DocumentReference workoutRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(workoutID);

      Timestamp dateTimestamp = Timestamp.fromDate(date);

      QuerySnapshot recordSnapshots = await workoutRef
          .collection('records')
          .where('date', isEqualTo: dateTimestamp)
          .get();

      if (recordSnapshots.docs.isEmpty) {
        appLogger.log(
            'No records found for workout $workoutID on ${DateFormat('yyyy-MM-dd').format(date)}');
        ToastManager.showError('No records found for the selected date');
        return;
      }

      WriteBatch batch = _firestore.batch();

      for (DocumentSnapshot doc in recordSnapshots.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      appLogger.log(
          'Deleted workout records for $workoutID on ${DateFormat('yyyy-MM-dd').format(date)}');
      ToastManager.showSuccess("Workout records deleted successfully ");
    } catch (e) {
      appLogger.error(
          'Error deleting workout records for $workoutID on ${DateFormat('yyyy-MM-dd').format(date)}: $e');
      ToastManager.showError('Error deleting workout records.');
    }
  }
}
