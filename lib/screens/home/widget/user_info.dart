import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gainz/resource/auth/auth_view_model.dart';
import 'package:gainz/resource/util/bottom_sheet_util.dart';
import 'package:gainz/screens/home/widget/record_bottom_sheet/record_bottom_sheet.dart';
import 'package:get/get.dart';

class UserInfo extends StatelessWidget {
  final AuthViewModel controller = Get.find();
  UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoggedIn()) {
        return GestureDetector(
          onTap: () {
            showAppBottomSheet(
              const RecordsBottomSheet(),
            );
          },
          child: SizedBox(
            height: 80,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0XFF1F6950).withOpacity(0.7),
                        const Color(0XFF14161E).withOpacity(0.7),
                        const Color(0XFF14161E).withOpacity(0.7),
                        const Color(0XFF1F6950).withOpacity(0.7),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (controller.userPhotoUrl.isNotEmpty)
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(controller.userPhotoUrl.value),
                            radius: 30,
                          ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hello ${controller.userName.value}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Welcome back to Gainz',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
