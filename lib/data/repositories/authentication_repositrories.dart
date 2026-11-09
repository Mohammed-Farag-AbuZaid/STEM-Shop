import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
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

  static const String _tfApiBaseUrl = 'https://n8n.tfunions.com/tf-api';

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  void screenRedirect() async {
    final vpsUser = deviceStorage.read('tf_vps_user');
    if (vpsUser != null) {
      Get.offAll(() => const NavigationMenu());
      return;
    }

    final user = _auth.currentUser;

    if (user != null) {
      if (user.emailVerified) {
        Map<String, dynamic> data = {};
        bool exists = false;
        try {
          final res = await http
              .get(Uri.parse('$_tfApiBaseUrl/api/collections/users/${user.uid}'))
              .timeout(const Duration(seconds: 6));
          if (res.statusCode == 200) {
            final body = jsonDecode(res.body) as Map<String, dynamic>;
            data = (body['data'] as Map<String, dynamic>?) ?? body;
            exists = true;
          }
        } catch (_) {}

        if (!exists) {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          exists = doc.exists;
          data = doc.data() ?? {};
        }

        if (!exists ||
            data['stemSchool'] == null ||
            (data['stemSchool'] as String).isEmpty) {
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

  Future<UserCredential?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse('$_tfApiBaseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        await deviceStorage.write('tf_vps_token', body['access_token']);
        await deviceStorage.write('tf_vps_user', body['user']);
        return null;
      }
    } catch (_) {}

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
      await deviceStorage.remove('tf_vps_token');
      await deviceStorage.remove('tf_vps_user');
      try {
        await GoogleSignIn().signOut();
      } catch (_) {}
      await FirebaseAuth.instance.signOut();
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
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await userAccount?.authentication;
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
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
