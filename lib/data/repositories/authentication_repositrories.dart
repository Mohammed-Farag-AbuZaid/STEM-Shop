import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stem_shop/features/authentication/controllers/login/email_verification.dart';
import 'package:stem_shop/features/authentication/loging/login.dart';
import 'package:stem_shop/features/authentication/screens/onBoarding/onboarding.dart';
import 'package:stem_shop/features/authentication/screens/update_user_info/change_academciinfo_screen.dart';
import 'package:stem_shop/navigation_menu.dart';
import 'package:stem_shop/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:stem_shop/utils/exceptions/firebase_exceptions.dart';
import 'package:stem_shop/utils/exceptions/formate_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  void screenRedirect() async {
    var user = _auth.currentUser;

    if (user != null) {
      try {
        await user.reload();
        user = _auth.currentUser;
      } catch (_) {}
    }

    if (user != null) {
      if (user.emailVerified) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final data = doc.data() ?? <String, dynamic>{};

        if (!doc.exists ||
            data['stemSchool'] == null ||
            data['stemSchool'].toString().trim().isEmpty) {
          Get.offAll(
            () => const ChangeAcademicInfo(
              showBackArrow: false,
              fullMessage: false,
              title: 'Your Account Setup is Incomplete',
              description:
                  'It looks like your account information has not been fully set up yet. Please visit the TF Passport portal to complete your registration and account details.',
            ),
          );
        } else {
          Get.offAll(() => const NavigationMenu());
        }
      } else {
        Get.offAll(() => const EmailVerification());
      }
    } else {
      deviceStorage.writeIfNull('IsFirstTime', true);
      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(const OnBoardingScreen());
    }
  }

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
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> logout() async {
    try {
      if (!kIsWeb) {
        try {
          await GoogleSignIn().signOut();
        } catch (_) {}
      }
      await _auth.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider()
          ..addScope('email')
          ..addScope('profile');
        return await _auth.signInWithPopup(googleProvider);
      }

      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();
      if (userAccount == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await userAccount.authentication;
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credentials);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } catch (e) {
      if (kDebugMode) print('Something went wrong: $e');
      return null;
    }
  }
}
