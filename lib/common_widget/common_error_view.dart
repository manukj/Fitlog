import 'package:flutter/widgets.dart';

class CommonErrorView extends StatelessWidget {
  final String title;
  final String? discription;
  final String? imagePath;
  const CommonErrorView({
    super.key,
    required this.title,
    this.discription,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        if (discription != null) Text(discription!),
        if (imagePath != null) Image.asset(imagePath!),
      ],
    );
  }
}
