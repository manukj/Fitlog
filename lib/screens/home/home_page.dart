import 'package:flutter/material.dart';
import 'package:gainz/common_widget/primary_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Hello, World!'),
          PrimaryButton(
            onPressed: () {},
            text: "Click Me",
          ),
        ],
      ),
    );
  }
}
