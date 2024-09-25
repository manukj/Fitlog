import 'package:Vyayama/common_widget/primary_button.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class CommonErrorView extends StatelessWidget {
  final String title;
  final String? discription;
  final String? imagePath;
  final String? lottiePath;
  final String? buttonTitle;
  final VoidCallback? onButtonPressed;
  final Widget? buttonPrefix;

  const CommonErrorView({
    super.key,
    required this.title,
    this.discription,
    this.imagePath,
    this.lottiePath,
    this.buttonTitle,
    this.onButtonPressed,
    this.buttonPrefix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (lottiePath != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Lottie.asset(
                      lottiePath!,
                      height: 200,
                    ),
                  ),
                if (imagePath != null) Image.asset(imagePath!),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (discription != null) Text(discription!),
              ],
            ),
          ),
          if (buttonTitle != null && onButtonPressed != null)
            PrimaryButton(
              text: buttonTitle,
              onPressed: onButtonPressed,
              prefix: buttonPrefix,
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
