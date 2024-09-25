import 'package:Vyayama/resource/theme/theme.dart';
import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  const CommonScaffold(
      {super.key, required this.body, this.floatingActionButton, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      backgroundColor: AppThemedata.surface,
      floatingActionButton: floatingActionButton,
      appBar: appBar,
    );
  }
}
