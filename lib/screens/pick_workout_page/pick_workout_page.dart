import 'package:Vyayama/screens/home/home_page.dart';
import 'package:Vyayama/screens/home/model/workout_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickWorkoutPage extends StatelessWidget {
  const PickWorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "Pick a Workout",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
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
                    Get.to(() => HomePage(workout: workout));
                  },
                  child: Card(
                    elevation: 4.0,
                    child: Column(
                      children: [
                        Expanded(
                          child: Hero(
                            tag: workout.image,
                            child: Image.asset(
                              workout.image,
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Hero(
                            tag: workout.image + workout.name,
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                workout.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
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
    );
  }
}
