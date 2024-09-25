import 'dart:ui';

import 'package:Vyayama/resource/auth/auth_view_model.dart';
import 'package:Vyayama/resource/theme/theme.dart';
import 'package:Vyayama/screens/home/model/workout_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInfoAndWorkoutName extends StatelessWidget {
  final Workout workout;
  final AuthViewModel controller = Get.find();
  UserInfoAndWorkoutName({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
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
            child: SingleChildScrollView(
              child: Obx(() {
                var isLogged = controller.isLoading.value;
                return Column(
                  children: [
                    const SizedBox(height: 15),
                    if (controller.isLoading.value)
                      const LinearProgressIndicator(
                        color: AppThemedata.primary,
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildProfilePic(isLogged),
                        _buildWorkoutInfo(),
                        Container(),
                        // _buildLoginLogourButton(isLogged),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Row _buildWorkoutInfo() {
    return Row(
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  GestureDetector _buildLoginLogourButton(bool isLogged) {
    return GestureDetector(
      onTap: () {
        if (isLogged) {
          controller.signOut();
        } else {
          controller.signInWithGoogle();
        }
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.white,
              width: 1.0,
            ),
          ),
        ),
        child: Icon(
          isLogged ? Icons.login_outlined : Icons.logout_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  _buildProfilePic(isLogged) {
    return (isLogged && controller.userPhotoUrl.isNotEmpty)
        ? CircleAvatar(
            backgroundImage: NetworkImage(controller.userPhotoUrl.value),
            radius: 30,
          )
        : Container();
  }
}
