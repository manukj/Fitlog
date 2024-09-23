import 'package:Vyayama/resource/theme/theme.dart';
import 'package:flutter/material.dart';

class CommonCard extends StatelessWidget {
  final Widget child;
  const CommonCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppThemedata.surface.withOpacity(0.1),
      elevation: 4.0,
      child: child,
    );
  }
}
