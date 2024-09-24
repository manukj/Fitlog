import 'dart:ui';

import 'package:Vyayama/resource/auth/auth_view_model.dart';
import 'package:Vyayama/resource/util/bottom_sheet_util.dart';
import 'package:Vyayama/screens/home/model/workout_list.dart';
import 'package:Vyayama/screens/home/view_model/record_view_model.dart';
import 'package:Vyayama/screens/home/widget/record_bottom_sheet/record_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfo extends StatelessWidget {
  final Workout workout;
  final AuthViewModel controller = Get.find();
  UserInfo({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: Get.width,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            alignment: Alignment.center,
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
            child: Column(
              children: [
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      workout.image,
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(width: 10),
                    Material(
                      color: Colors.transparent,
                      child: Text(
                        workout.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator()),
                        SizedBox(width: 20),
                        Text(
                          "Please Wait...",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    );
                  } else if (controller.isLoggedIn()) {
                    return _buildUserinfo();
                  } else {
                    return Container();
                    return GestureDetector(
                      onTap: () => controller.signInWithGoogle(),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildUserinfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () {
            Get.find<RecordViewModel>().fetchRecords();
            showAppBottomSheet(
              const RecordsBottomSheet(),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (controller.userPhotoUrl.isNotEmpty)
                CircleAvatar(
                  backgroundImage: NetworkImage(controller.userPhotoUrl.value),
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
                    'Welcome back ',
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
        GestureDetector(
          onTap: () {
            controller.signOut();
          },
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
            ),
            child: const Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
