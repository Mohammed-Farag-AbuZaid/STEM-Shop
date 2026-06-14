import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stem_shop/features/authentication/screens/onBoarding/onboarding.dart';
import 'package:stem_shop/navigation_menu.dart';
import 'package:stem_shop/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:stem_shop/utils/exceptions/firebase_exceptions.dart';
import 'package:stem_shop/utils/exceptions/formate_exceptions.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  /// called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  /// Function to show relevan screen based on user login status
  Future<void> screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      if (user.emailVerified) {
        Get.offAll(() => const NavigationMenu());
      } else {
        TLoaders.errorSnackBar(
          title: 'Email Not Verified',
          message:
              'This Error means that you have not verified your email address. Please check your inbox and click on the verification link to verify your email address. If you have not received the email, please check your spam folder.',
        );
      }
    } else {
      Get.offAll(() => const OnBoardingScreen());
    }
    // local storage check for user login status
    deviceStorage.writeIfNull('IsFirstTime', true);
    deviceStorage.read('IsFirstTime') != true && user != null
        ? Get.offAll(() => const NavigationMenu())
        : Get.offAll(() => const OnBoardingScreen());
  }

 /// EmailAuthentication
  Future<UserCredential> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code);
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
