import 'package:Vyayama/resource/constants/assets_path.dart';

class WorkoutList {
  static const List<Workout> workouts = [
    Workout('Barbell row', AssetsPath.barbellRow, 1),
    Workout('Bench press', AssetsPath.benchPress, 2),
    Workout('Shoulder press', AssetsPath.shoulderPress, 3),
    Workout('Deadlift', AssetsPath.deadlift, 4),
    Workout('Squat', AssetsPath.squat, 5),
  ];
}

class Workout {
  final String name;
  final String image;
  final int id;

  const Workout(this.name, this.image, this.id);
}
