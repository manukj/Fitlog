import 'package:flutter/material.dart';
import 'package:gainz/resource/theme/theme.dart';
import 'package:get/get.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';

class PrimaryButton extends StatelessWidget {
  final Widget? child;
  final Widget? prefix;
  final String? text;
  final VoidCallback? onPressed;
  final double? width;
  final Color color;
  final bool showShimmer;
  final TextStyle? textStyle;

  const PrimaryButton({
    super.key,
    this.child,
    this.text,
    this.width,
    this.onPressed,
    this.showShimmer = true,
    this.color = AppThemedata.primary,
    this.prefix,
    this.textStyle,
  }) : assert(child != null || text != null,
            'You must provide either a child or a text');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 60,
      child: NeoPopTiltedButton(
        isFloating: true,
        onTapUp: onPressed,
        decoration: NeoPopTiltedButtonDecoration(
          color: color,
          plunkColor: color.withOpacity(0.5),
          shadowColor: const Color.fromARGB(255, 19, 19, 33),
          showShimmer: showShimmer,
        ),
        child: child ??
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefix != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: prefix!,
                    ),
                  Text(
                    text ?? '',
                    style: textStyle ??
                        const TextStyle(
                          color: Color(0xFF0A0A12),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
