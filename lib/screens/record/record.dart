import 'package:flutter/material.dart';
import 'package:gainz/common_widget/primary_button.dart';
import 'package:gainz/screens/home/home_page.dart';
import 'package:get/get.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PrimaryButton(
          onPressed: () {
            Get.offAll(() => HomePage());
          },
          text: 'Restart',
        ),
      ),
    );
  }
}
