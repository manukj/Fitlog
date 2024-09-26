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

  Future<void> saveWorkoutRecord(
      String workoutID, int reps, double weight) async {
    try {
      // Step 1: Ensure the workout document exists (or create it if not)
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
        print('Created workout document for workoutID: $workoutID');
      }

      // Step 2: Check if a record already exists for today
      QuerySnapshot querySnapshot = await workoutRef
          .collection('records')
          .where('date', isEqualTo: Timestamp.fromDate(DateUtil.getToday()))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If a record for today exists, update it
        DocumentSnapshot doc = querySnapshot.docs.first;
        int previousReps = doc['reps'];
        double previousWeight = doc['weight'];

        await workoutRef.collection('records').doc(doc.id).update({
          'reps': previousReps + reps,
          'weight': previousWeight > weight ? previousWeight : weight,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // If no record exists for today, create a new one
        await workoutRef.collection('records').add({
          'date': Timestamp.fromDate(DateUtil.getToday()),
          'reps': reps,
          'weight': weight,
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
      // Step 1: Fetch all workout documents for the user
      QuerySnapshot workoutSnapshots = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .get();

      List<String> workoutIDs =
          workoutSnapshots.docs.map((doc) => doc.id).toList();

      // Step 2: For each workout document, fetch its records
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

          // Map each document to a WorkoutRecord and add to the list
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
}
