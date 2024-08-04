import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gainz/common_widget/primary_button.dart';
import 'package:gainz/resource/logger/logger.dart';
import 'package:get/route_manager.dart';
import 'package:toastification/toastification.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        routingCallback: (routing) {
          if (kDebugMode) {
            appLogger.debug('Routing to: ${routing?.current}');
          }
        },
        home: Scaffold(
          body: Center(
            child: PrimaryButton(
              onPressed: () {},
              text: 'Click me',
            ),
          ),
        ),
      ),
    );
  }
}
