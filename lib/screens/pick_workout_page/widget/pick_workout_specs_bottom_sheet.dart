import 'package:Vyayama/common_widget/primary_button.dart';
import 'package:Vyayama/screens/home/home_page.dart';
import 'package:Vyayama/screens/home/model/workout_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickWorkoutSpecsBottomSheet extends StatefulWidget {
  final Workout workout;
  const PickWorkoutSpecsBottomSheet({super.key, required this.workout});

  @override
  State<PickWorkoutSpecsBottomSheet> createState() =>
      _PickWorkoutSpecsBottomSheetState();
}

class _PickWorkoutSpecsBottomSheetState
    extends State<PickWorkoutSpecsBottomSheet> {
  int selectedWeight = 10;
  int selectedReps = 3;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.workout.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Image.asset(
            widget.workout.image,
            height: 80,
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPickerRow(
                label: 'Weight (kg)',
                selectedValue: selectedWeight,
                itemRange: 51,
                unit: 'kg',
                onChanged: (index) => setState(() => selectedWeight = index),
              ),
              Container(
                height: 120,
                width: 1,
                color: Colors.grey[600],
              ),
              _buildPickerRow(
                label: 'Target Reps',
                selectedValue: selectedReps - 1,
                itemRange: 11,
                unit: 'reps',
                onChanged: (index) => setState(() => selectedReps = index + 1),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          PrimaryButton(
            onPressed: () {
              Get.to(() => HomePage(workout: widget.workout));
            },
            text: 'Proceed',
          ),
        ],
      ),
    );
  }

  Widget _buildPickerRow({
    required String label,
    required int selectedValue,
    required int itemRange,
    required String unit,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 100,
          width: 100,
          child: CupertinoPicker(
            scrollController:
                FixedExtentScrollController(initialItem: selectedValue),
            itemExtent: 40,
            onSelectedItemChanged: onChanged,
            children: List<Widget>.generate(itemRange, (int index) {
              return Center(child: Text('$index $unit'));
            }),
          ),
        ),
      ],
    );
  }
}
