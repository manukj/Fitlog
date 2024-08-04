import 'package:flutter/material.dart';
import 'package:gainz/resource/theme/theme.dart';
import 'package:get/get.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';

class PrimaryButton extends StatelessWidget {
  final Widget? child;
  final String? text;
  final VoidCallback onPressed;
  final double? width;

  const PrimaryButton({
    super.key,
    this.child,
    this.text,
    this.width,
    required this.onPressed,
  }) : assert(child != null || text != null,
            'You must provide either a child or a text');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? Get.width - 40,
      height: 60,
      child: NeoPopTiltedButton(
        isFloating: true,
        onTapUp: onPressed,
        decoration: NeoPopTiltedButtonDecoration(
          color: AppThemedata.primary,
          plunkColor: AppThemedata.primary.withOpacity(0.5),
          shadowColor: AppThemedata.shadowColor,
          showShimmer: true,
        ),
        child: child ??
            Center(
              child: Text(
                text ?? '',
                style: const TextStyle(
                  color: Color(0xFF0A0A12),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      ),
    );
  }
}
