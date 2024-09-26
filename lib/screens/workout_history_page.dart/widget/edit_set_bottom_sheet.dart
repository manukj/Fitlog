import 'package:Vyayama/common_widget/common_error_view.dart';
import 'package:Vyayama/common_widget/primary_button.dart';
import 'package:Vyayama/resource/constants/assets_path.dart';
import 'package:Vyayama/resource/firebase/model/workour_records.dart';
import 'package:Vyayama/resource/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditSetsBottomSheet extends StatelessWidget {
  final List<SetRecord> sets;
  final VoidCallback onSave;
  final void Function(SetRecord) onDeleteSet;

  const EditSetsBottomSheet({
    super.key,
    required this.sets,
    required this.onSave,
    required this.onDeleteSet,
  });

  @override
  Widget build(BuildContext context) {
    if (sets.isEmpty) {
      return CommonErrorView(
        title: 'No sets found',
        buttonTitle: 'Start Workout',
        lottiePath: AssetsPath.emptyList,
        onButtonPressed: () {
          Get.back();
        },
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary of Sets',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sets.length,
              itemBuilder: (context, index) {
                return SetRow(
                  onDelete: () => onDeleteSet(sets[index]),
                  index: index,
                  set: sets[index],
                  onChanged: (updatedSet) {
                    sets[index] = updatedSet; // Update the set in the list
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            color: const Color(0xFF0A0A12),
            textColor: AppThemedata.primary,
            text: 'Save',
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}

class SetRow extends StatelessWidget {
  final int index;
  final SetRecord set;
  final ValueChanged<SetRecord> onChanged;
  final VoidCallback onDelete;

  const SetRow({
    super.key,
    required this.index,
    required this.set,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController repsController =
        TextEditingController(text: set.reps.toString());
    final TextEditingController weightController =
        TextEditingController(text: set.weight.toStringAsFixed(1));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            'Set ${index + 1}:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Reps',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                int updatedReps = int.tryParse(value) ?? set.reps;
                onChanged(SetRecord(reps: updatedReps, weight: set.weight));
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                double updatedWeight = double.tryParse(value) ?? set.weight;
                onChanged(SetRecord(reps: set.reps, weight: updatedWeight));
              },
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
