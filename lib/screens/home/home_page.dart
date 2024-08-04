import 'package:flutter/material.dart';
import 'package:gainz/common_widget/primary_button.dart';
import 'package:gainz/screens/home/widget/camera_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CameraWidget(),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: PrimaryButton(
              onPressed: () {},
              text: 'Start Workout',
            ),
          ),
        ],
      ),
    );
  }
}
