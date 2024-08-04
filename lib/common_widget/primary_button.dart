import 'package:flutter/material.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';

class PrimaryButton extends StatelessWidget {
  final Widget? child;
  final String? text;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    this.child,
    this.text,
    required this.onPressed,
  }) : assert(child != null || text != null,
            'You must provide either a child or a text');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: NeoPopTiltedButton(
        isFloating: true,
        onTapUp: onPressed,
        decoration: const NeoPopTiltedButtonDecoration(
          color: Color(0xFF1E2C44),
          plunkColor: Color.fromARGB(255, 37, 52, 79),
          shadowColor: Color.fromRGBO(36, 36, 36, 1),
          showShimmer: true,
          // shimmerColor: Color(0xFF204E41),
        ),
        child: child ??
            Center(
              child: Text(
                text ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      ),
    );
  }
}
