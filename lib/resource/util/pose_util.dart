import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseUtil {
  bool isStartPosition(Pose pose) {
    const double feetTogetherThreshold = 0.1;
    const double armsAtSidesThreshold = 0.2;

    PoseLandmark leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle]!;
    PoseLandmark rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle]!;
    PoseLandmark leftWrist = pose.landmarks[PoseLandmarkType.leftWrist]!;
    PoseLandmark rightWrist = pose.landmarks[PoseLandmarkType.rightWrist]!;
    PoseLandmark leftHip = pose.landmarks[PoseLandmarkType.leftHip]!;
    PoseLandmark rightHip = pose.landmarks[PoseLandmarkType.rightHip]!;

    return (leftAnkle.x - rightAnkle.x).abs() < feetTogetherThreshold &&
        (leftWrist.y - leftHip.y).abs() < armsAtSidesThreshold &&
        (rightWrist.y - rightHip.y).abs() < armsAtSidesThreshold;
  }

  bool isJumpingPosition(Pose pose) {
    const double feetApartThreshold = 0.5;
    const double armsAboveHeadThreshold = 0.2;

    PoseLandmark leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle]!;
    PoseLandmark rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle]!;
    PoseLandmark leftWrist = pose.landmarks[PoseLandmarkType.leftWrist]!;
    PoseLandmark rightWrist = pose.landmarks[PoseLandmarkType.rightWrist]!;
    PoseLandmark leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder]!;
    PoseLandmark rightShoulder =
        pose.landmarks[PoseLandmarkType.rightShoulder]!;

    return (leftAnkle.x - rightAnkle.x).abs() > feetApartThreshold &&
        (leftWrist.y < leftShoulder.y - armsAboveHeadThreshold) &&
        (rightWrist.y < rightShoulder.y - armsAboveHeadThreshold);
  }

  int countJumpingJacks(List<Pose> poses) {
    bool wasInStartPosition = false;
    int jumpingJackCount = 0;

    for (Pose pose in poses) {
      if (isStartPosition(pose)) {
        wasInStartPosition = true;
      } else if (wasInStartPosition && isJumpingPosition(pose)) {
        jumpingJackCount++;
        wasInStartPosition = false; // Ensure to count only once per cycle
      }
    }

    return jumpingJackCount;
  }
}
