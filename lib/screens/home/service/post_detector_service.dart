import 'package:gainz/resource/logger/logger.dart';
import 'package:gainz/screens/home/service/i_pose_detector_service.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

enum JumpingJackStatus {
  standing,
  jumpOut, // when legs are spread and hands are above
  jumpIn, // when you bring your legs together and lowering the arm
}

class PoseDetectorService {
  final IPoseDetectorService _iPoseDetectorService;
  var totalJumpingJacks = 0;
  var previousJumpingJackStatus = JumpingJackStatus.standing;

  PoseDetectorService(this._iPoseDetectorService);

  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(),
  );

  Future<List<Pose>> detectPose(InputImage inputImage) async {
    final poses = await _poseDetector.processImage(inputImage);
    // checkTheStatusOfPoses(poses);
    return poses;
  }

  void checkTheStatusOfPoses(List<Pose> poses) async {
    var currentJumpingJackStatus = JumpingJackStatus.standing;
    if (poses.isEmpty) {
      appLogger.debug('No Person Found');
      return _iPoseDetectorService.noPersonFound();
    }
    final Pose pose = poses.first;

    final PoseLandmark leftShoulder =
        pose.landmarks[PoseLandmarkType.leftShoulder]!;
    final PoseLandmark rightShoulder =
        pose.landmarks[PoseLandmarkType.rightShoulder]!;
    final PoseLandmark leftHip = pose.landmarks[PoseLandmarkType.leftHip]!;
    final PoseLandmark rightHip = pose.landmarks[PoseLandmarkType.rightHip]!;
    final PoseLandmark leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle]!;
    final PoseLandmark rightAnkle =
        pose.landmarks[PoseLandmarkType.rightAnkle]!;
    final PoseLandmark leftWrist = pose.landmarks[PoseLandmarkType.leftWrist]!;
    final PoseLandmark rightWrist =
        pose.landmarks[PoseLandmarkType.rightWrist]!;

    final double shoulderDistance = (leftShoulder.x - rightShoulder.x).abs();
    final double hipDistance = (leftHip.x - rightHip.x).abs();
    final double ankleDistance = (leftAnkle.x - rightAnkle.x).abs();
    final bool handsAboveShoulders =
        leftWrist.y < leftShoulder.y && rightWrist.y < rightShoulder.y;

    appLogger.debug('Hands Above Shoulders: $handsAboveShoulders');
    appLogger.debug('Shoulder Distance: $shoulderDistance');
    appLogger.debug('Hip Distance: $hipDistance');
    appLogger.debug('Ankle Distance: $ankleDistance');

    if (ankleDistance > hipDistance * 1.5 && handsAboveShoulders) {
      appLogger.debug('Jumping Jacks: Jump Out');
      currentJumpingJackStatus = JumpingJackStatus.jumpOut;
    } else if (ankleDistance < shoulderDistance * 1.2 && !handsAboveShoulders) {
      appLogger.debug('Jumping Jacks: Jump In');
      currentJumpingJackStatus = JumpingJackStatus.jumpIn;
    } else {
      appLogger.debug('Jumping Jacks: Standing');
      currentJumpingJackStatus = JumpingJackStatus.standing;
    }

    if (currentJumpingJackStatus == JumpingJackStatus.jumpOut &&
        previousJumpingJackStatus == JumpingJackStatus.jumpIn) {
      totalJumpingJacks++;
      appLogger.debug('Total Jumping Jacks: $totalJumpingJacks');
    }

    previousJumpingJackStatus = currentJumpingJackStatus;
  }
}
