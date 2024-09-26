import 'package:Vyayama/resource/constants/assets_path.dart';

enum WorkouTypeEnums {
  jumpingJacks,
  barbellRow,
  benchPress,
  shoulderPress,
  deadlift,
  squat,
}

class WorkoutList {
  static List<Workout> workouts = [
    Workout('Bench press', AssetsPath.benchPress, WorkouTypeEnums.benchPress),
    Workout('Shoulder press', AssetsPath.shoulderPress,
        WorkouTypeEnums.shoulderPress),
    Workout('Deadlift', AssetsPath.deadlift, WorkouTypeEnums.deadlift),
    Workout('Squat', AssetsPath.squat, WorkouTypeEnums.squat),
    Workout(
        'Jumping Jack', AssetsPath.jumpingJack, WorkouTypeEnums.jumpingJacks),
    Workout('Barbell row', AssetsPath.barbellRow, WorkouTypeEnums.barbellRow),
  ];
}

class Workout {
  final String name;
  final String image;
  final WorkouTypeEnums type;
  int reps = 0;
  int weight = 0;

  Workout(this.name, this.image, this.type);

  void setReps(int reps) {
    this.reps = reps;
  }

  void setWeight(int weight) {
    this.weight = weight;
  }
}
