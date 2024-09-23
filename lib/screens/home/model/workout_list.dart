import 'package:Vyayama/resource/constants/assets_path.dart';

enum WorkouTypeEnums {
  JumpingJacks,
  BarbellRow,
  BenchPress,
  ShoulderPress,
  Deadlift,
  Squat,
}

class WorkoutList {
  static const List<WorkoutType> workouts = [
    WorkoutType(
        'Barbell row', AssetsPath.barbellRow, WorkouTypeEnums.BarbellRow),
    WorkoutType(
        'Bench press', AssetsPath.benchPress, WorkouTypeEnums.BenchPress),
    WorkoutType('Shoulder press', AssetsPath.shoulderPress,
        WorkouTypeEnums.ShoulderPress),
    WorkoutType('Deadlift', AssetsPath.deadlift, WorkouTypeEnums.Deadlift),
    WorkoutType('Squat', AssetsPath.squat, WorkouTypeEnums.Squat),
    WorkoutType(
        'Jumping Pack', AssetsPath.jumpingJack, WorkouTypeEnums.JumpingJacks),
  ];
}

class WorkoutType {
  final String name;
  final String image;
  final WorkouTypeEnums type;

  const WorkoutType(this.name, this.image, this.type);
}
