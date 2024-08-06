import 'package:flutter/material.dart';
import 'package:gainz/resource/constants/assets_path.dart';
import 'package:lottie/lottie.dart';

class CommonLoader extends StatelessWidget {
  final String loadingMessage;
  const CommonLoader({super.key, this.loadingMessage = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          AssetsPath.jumpingJackAnimation,
          height: 200,
        ),
        Text(
          loadingMessage,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
