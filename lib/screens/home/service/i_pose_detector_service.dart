import 'package:flutter/widgets.dart';
import 'package:Vyayama/screens/home/service/post_detector_service.dart';

abstract class IPoseDetectorService {
  void noPersonFound();

  void onPoseDetected(CustomPaint customPaint);

  void onPoseStatus(JumpingJackStatus status);

  void onJumpingJackCompleted(int count);
}
