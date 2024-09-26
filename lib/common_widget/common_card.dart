import 'package:Vyayama/resource/theme/theme.dart';
import 'package:flutter/material.dart';

class CommonCard extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  const CommonCard({super.key, required this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: AppThemedata.surface.withOpacity(0.1),
        elevation: 4.0,
        child: child,
      ),
    );
  }
}
