import 'package:flutter/material.dart';
import 'package:Vyayama/resource/constants/assets_path.dart';
import 'package:Vyayama/resource/theme/theme.dart';
import 'package:lottie/lottie.dart';

class CommonLoader extends StatelessWidget {
  final String loadingMessage;
  const CommonLoader({super.key, this.loadingMessage = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppThemedata.surface,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            AssetsPath.jumpingJackAnimation,
            height: 300,
          ),
          Text(
            loadingMessage,
            style: const TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
