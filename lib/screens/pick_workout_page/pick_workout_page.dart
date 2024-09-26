import 'package:Vyayama/common_widget/common_card.dart';
import 'package:Vyayama/common_widget/common_scaffold.dart';
import 'package:Vyayama/resource/theme/theme.dart';
import 'package:Vyayama/resource/util/bottom_sheet_util.dart';
import 'package:Vyayama/screens/home/model/workout_list.dart';
import 'package:Vyayama/screens/pick_workout_page/widget/pick_workout_specs_bottom_sheet.dart';
import 'package:Vyayama/screens/workout_list_page.dart/workout_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickWorkoutPage extends StatelessWidget {
  const PickWorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppThemedata.primary,
        onPressed: () {
          Get.to(() => WorkoutListPage());
        },
        child: const Icon(
          Icons.list,
          color: AppThemedata.surface,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                "Welcome to",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppThemedata.onSuraface.withOpacity(0.8)),
              ),
              const Text(
                "FitLog",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height - 250,
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: WorkoutList.workouts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 columns
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1, // Aspect ratio for square tiles
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final workout = WorkoutList.workouts[index];
                    return GestureDetector(
                      onTap: () {
                        showAppBottomSheet(
                          PickWorkoutSpecsBottomSheet(workout: workout),
                        );
                      },
                      child: CommonCard(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              workout.image,
                              height: 50,
                              width: 50,
                              fit: BoxFit.scaleDown,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  workout.name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
