import 'package:Vyayama/resource/logger/logger.dart';
import 'package:Vyayama/resource/theme/theme.dart';
import 'package:Vyayama/screens/pick_workout_page/pick_workout_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:toastification/toastification.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: SafeArea(
        child: GetMaterialApp(
          theme: ThemeData.dark(),
          darkTheme: AppThemedata.dark(),
          debugShowCheckedModeBanner: false,
          routingCallback: (routing) {
            if (kDebugMode) {
              appLogger.debug('Routing to: ${routing?.current}');
            }
          },
          home: const PickWorkoutPage(),
        ),
      ),
    );
  }
}
