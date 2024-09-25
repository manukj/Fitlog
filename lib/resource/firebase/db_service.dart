import 'package:Vyayama/resource/auth/auth_view_model.dart';
import 'package:Vyayama/resource/firebase/model/workour_records.dart';
import 'package:Vyayama/resource/toast/toast_manager.dart';
import 'package:Vyayama/resource/util/date_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  final AuthViewModel authViewModel;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DbService(this.authViewModel);

  String get userId => authViewModel.user?.uid ?? '';

  // Save or update a workout record
  Future<void> saveWorkoutRecord(
      String workoutID, int reps, double weight) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(workoutID)
          .collection('records')
          .where('date', isEqualTo: Timestamp.fromDate(DateUtil.getToday()))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If record for today exists, update it
        DocumentSnapshot doc = querySnapshot.docs.first;
        int previousReps = doc['reps'];
        double previousWeight = doc['weight'];

        await _firestore
            .collection('users')
            .doc(userId)
            .collection('workouts')
            .doc(workoutID)
            .collection('records')
            .doc(doc.id)
            .update({
          'reps': previousReps + reps,
          'weight': previousWeight > weight ? previousWeight : weight,
        });
      } else {
        // If no record exists for today, add a new one
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('workouts')
            .doc(workoutID)
            .collection('records')
            .add({
          'date': Timestamp.fromDate(DateUtil.getToday()),
          'reps': reps,
          'weight': weight,
        });
      }
    } catch (e) {
      ToastManager.showError(e.toString());
    }
  }

  // Fetch workout records for a specific workoutID
  Future<List<WorkoutRecord>> fetchWorkoutRecords(String workoutID) async {
    List<WorkoutRecord> workoutRecords = [];
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(workoutID)
          .collection('records')
          .orderBy('date', descending: false)
          .get();

      workoutRecords = querySnapshot.docs.map((doc) {
        return WorkoutRecord.fromMap(
            workoutID, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      ToastManager.showError(e.toString());
    }
    return workoutRecords;
  }

  // Fetch all workout records for the current user
  Future<List<WorkoutRecord>> fetchAllWorkoutRecords() async {
    List<WorkoutRecord> allWorkoutRecords = [];
    try {
      // Step 1: Fetch all workout IDs
      QuerySnapshot workoutSnapshots = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .get();

      List<String> workoutIDs =
          workoutSnapshots.docs.map((doc) => doc.id).toList();

      // Step 2: Fetch all records for each workoutID
      for (String workoutID in workoutIDs) {
        QuerySnapshot recordSnapshots = await _firestore
            .collection('users')
            .doc(userId)
            .collection('workouts')
            .doc(workoutID)
            .collection('records')
            .orderBy('date', descending: false)
            .get();

        // Map each document to a WorkoutRecord and add to the list
        List<WorkoutRecord> workoutRecords = recordSnapshots.docs.map((doc) {
          return WorkoutRecord.fromMap(
              workoutID, doc.data() as Map<String, dynamic>);
        }).toList();

        allWorkoutRecords.addAll(workoutRecords);
      }
    } catch (e) {
      ToastManager.showError(e.toString());
    }
    return allWorkoutRecords;
  }

  // Fetch all workout IDs for the current user
  Future<List<String>> fetchWorkoutIDs() async {
    List<String> workoutIDs = [];
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .get();

      workoutIDs = querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      ToastManager.showError(e.toString());
    }
    return workoutIDs;
  }

  // Delete a workout by workoutID
  Future<void> deleteWorkout(String workoutID) async {
    try {
      // Step 1: Fetch all records for the workoutID and delete them
      QuerySnapshot recordSnapshots = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(workoutID)
          .collection('records')
          .get();

      for (DocumentSnapshot doc in recordSnapshots.docs) {
        await doc.reference.delete();
      }

      // Step 2: Delete the workout document itself
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(workoutID)
          .delete();

      ToastManager.showSuccess("Workout deleted successfully");
    } catch (e) {
      ToastManager.showError(e.toString());
    }
  }
}
