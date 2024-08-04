import 'package:flutter/material.dart';

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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        shadowColor: Colors.transparent,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF3A3A3A),
              Color(0xFF212121)
            ], // Adjust to match your gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          alignment: Alignment.center,
          child: child ??
              Text(
                text!,
                style: const TextStyle(color: Colors.white),
              ),
        ),
      ),
    );
  }
}
