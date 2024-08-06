import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gainz/resource/theme/theme.dart';
import 'package:gainz/screens/home/view_model/pose_detector_view_model.dart';
import 'package:get/get.dart';

class StopwatchWidget extends StatefulWidget {
  final bool start;

  const StopwatchWidget({super.key, required this.start});

  @override
  State<StopwatchWidget> createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  final PoseDetectorViewModel viewModel = Get.find<PoseDetectorViewModel>();
  late int _secondsElapsed;
  late final Stopwatch _stopwatch;
  late final Ticker _ticker;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _secondsElapsed = 0;
    _stopwatch = Stopwatch();
    _ticker = Ticker((Duration elapsed) {
      if (_stopwatch.isRunning) {
        setState(() {
          _secondsElapsed = _stopwatch.elapsed.inSeconds;
        });
      }
    });
    _ticker.start();
    _handleStartReset();
  }

  @override
  void didUpdateWidget(covariant StopwatchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.start != widget.start) {
      _handleStartReset();
    }
  }

  void _handleStartReset() {
    if (widget.start) {
      setState(() {
        _isAnimating = true;
      });
      Future.delayed(const Duration(seconds: 5), () {
        if (widget.start) {
          // Check again in case the flag changed during the delay
          _stopwatch.start();
        }
      });
    } else {
      setState(() {
        _secondsElapsed = 0;
        _isAnimating = false;
        _stopwatch.reset();
        _stopwatch.stop();
      });
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Center(
        child: AnimatedOpacity(
          opacity: _isAnimating ? 1 : 0,
          duration: const Duration(seconds: 2),
          child: Column(
            children: [
              AnimatedFlipCounter(
                prefix: "Time : ",
                suffix: " s",
                duration: const Duration(milliseconds: 500),
                value: _secondsElapsed,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Obx(() {
                return AnimatedFlipCounter(
                  prefix: "Total Reps : ",
                  duration: const Duration(milliseconds: 500),
                  value: viewModel.totalJumpingJack.value,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppThemedata.onSuraface,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
