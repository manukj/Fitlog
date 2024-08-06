import 'package:flutter/widgets.dart';

abstract class IPoseDetectorService {
  void noPersonFound();

  void onPoseDetected(int totalJumpingJacks, CustomPaint customPaint);
}
