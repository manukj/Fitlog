import 'package:firebase_auth/firebase_auth.dart';
import 'package:gainz/resource/logger/logger.dart';
import 'package:gainz/resource/toast/toast_manager.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _firebaseUser = Rxn<User>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  RxString userName = ''.obs;
  RxString userEmail = ''.obs;
  RxString userPhotoUrl = ''.obs;
  RxBool isLoading = false.obs;

  User? get user => _firebaseUser.value;

  bool isLoggedIn() {
    return _firebaseUser.value != null;
  }

  @override
  void onInit() {
    super.onInit();
    _firebaseUser.bindStream(_auth.authStateChanges());
    ever(_firebaseUser, _setUserDetails);
  }

  void _setUserDetails(User? user) {
    if (user != null) {
      userName.value = user.displayName ?? '';
      userEmail.value = user.email ?? '';
      userPhotoUrl.value = user.photoURL ?? '';
    } else {
      userName.value = '';
      userEmail.value = '';
      userPhotoUrl.value = '';
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);

        // Set user details
        userName.value = googleUser.displayName ?? '';
        userEmail.value = googleUser.email;
        userPhotoUrl.value = googleUser.photoUrl ?? '';
      }
    } catch (e) {
      appLogger.error('Error while signing in with Google: $e');
      ToastManager.showError("Login Failed");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
