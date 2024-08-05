import 'package:flutter/widgets.dart';

abstract class IPoseDetectorService {
  void noPersonFound();

  void onPoseDetected(CustomPaint customPaint);
}
