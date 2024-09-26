import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

abstract class IWorkoutDetector {
  IWorkoutDetector();

  void detectPose(CameraImage image, CameraDescription camera,
      CameraController cameraController);

  void checkTheStatusOfPoses(List<Pose> poses);

  void resetCount();

  void dispose();
}
