import 'package:Vyayama/resource/theme/theme.dart';
import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  const CommonScaffold(
      {super.key, required this.body, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      backgroundColor: AppThemedata.surface,
      floatingActionButton: floatingActionButton,
    );
  }
}
