import 'package:Vyayama/common_widget/primary_button.dart';
import 'package:Vyayama/resource/auth/auth_view_model.dart';
import 'package:Vyayama/resource/constants/assets_path.dart';
import 'package:Vyayama/resource/firebase/model/workour_records.dart';
import 'package:Vyayama/resource/theme/theme.dart';
import 'package:Vyayama/resource/toast/toast_manager.dart';
import 'package:Vyayama/resource/util/bottom_sheet_util.dart';
import 'package:Vyayama/resource/util/date_util.dart';
import 'package:Vyayama/screens/workout/view_model/record_view_model.dart';
import 'package:Vyayama/screens/workout/view_model/workout_detector_view_model.dart';
import 'package:Vyayama/screens/workout/widget/record_bottom_sheet/record_bottom_sheet.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SummaryWorkoutBottomSheet extends StatefulWidget {
  final num totalReps;
  const SummaryWorkoutBottomSheet({super.key, required this.totalReps});

  @override
  State<SummaryWorkoutBottomSheet> createState() =>
      _SummaryWorkoutBottomSheetState();
}

class _SummaryWorkoutBottomSheetState extends State<SummaryWorkoutBottomSheet> {
  final TextEditingController _repsController = TextEditingController();
  var isEditing = false.obs;
  late num totalReps;
  final WorkoutDetectorViewModel workoutDetectorViewModel =
      Get.find<WorkoutDetectorViewModel>();

  @override
  void initState() {
    super.initState();
    totalReps = widget.totalReps;
    _repsController.text = totalReps.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: totalReps == 0
          ? _buildNoRepWidget()
          : _buildRepSummaryWidget(context),
    );
  }

  Widget _buildRepSummaryWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Lottie.asset(
          AssetsPath.successAnimation,
          height: 200,
        ),
        Obx(() {
          return Column(
            children: [
              isEditing.value ? _buildEditMode() : _buildViewMode(),
            ],
          );
        }),
        const SizedBox(height: 40),
        Builder(builder: (context) {
          return PrimaryButton(
            onPressed: () async {
              await _saveProgress(context);
            },
            text: "Save Progress",
          );
        }),
      ],
    );
  }

  Widget _buildViewMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedFlipCounter(
          value: totalReps,
          prefix: "Total Reps: ",
          textStyle: const TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            isEditing.value = true;
          },
        ),
      ],
    );
  }

  Widget _buildEditMode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Editable text field with grey border
        SizedBox(
          width: 100,
          height: 60,
          child: TextField(
            cursorColor: AppThemedata.primary,
            controller: _repsController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              labelText: "Reps",
              labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppThemedata.primary), // Grey border
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppThemedata.primary),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.check,
            color: Colors.green,
          ),
          onPressed: _validateAndSaveReps,
        ),
      ],
    );
  }

  Widget _buildNoRepWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          "No Reps Detected",
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Lottie.asset(
          AssetsPath.warningAnimation,
          height: 200,
        ),
        const SizedBox(height: 20),
        _buildEditMode(), // Allow user to input reps even if no reps are detected
        const SizedBox(height: 20),
        PrimaryButton(
          color: const Color(0xFF0A0A12),
          textColor: AppThemedata.primary,
          onPressed: () {
            Get.back();
          },
          text: "Retry",
        ),
      ],
    );
  }

  void _validateAndSaveReps() {
    final newReps = int.tryParse(_repsController.text);
    if (newReps == null || newReps < 0) {
      ToastManager.showError("Please enter a valid number of reps");
      return;
    }

    setState(() {
      totalReps = newReps; // Update the totalJumpingJack in the state
      isEditing.value = false;
    });
  }

  Future<void> _saveProgress(BuildContext context) async {
    try {
      var authViewModel = Get.find<AuthViewModel>();
      if (!authViewModel.isLoggedIn()) {
        if (!await authViewModel.signInWithGoogle()) {
          ToastManager.showError("Login Failed");
          return;
        }
      }

      SetRecord set = SetRecord(
        reps: totalReps.toInt(),
        weight: workoutDetectorViewModel.workout.weight.toDouble(),
      );

      WorkoutRecord record = WorkoutRecord(
        date: DateUtil.getToday(),
        sets: [set],
        workoutID: workoutDetectorViewModel.workout.type.toString(),
      );
      await Get.find<RecordViewModel>().saveRecord(record);
      showAppBottomSheet(RecordsBottomSheet(record));
    } catch (e) {
      ToastManager.showError("Failed to save progress");
    }
  }
}
