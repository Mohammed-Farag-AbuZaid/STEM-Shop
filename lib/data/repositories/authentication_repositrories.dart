import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stem_shop/features/authentication/loging/login.dart';
import 'package:stem_shop/features/authentication/screens/onBoarding/onboarding.dart';
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

  Future<void> _ensureFirestoreProfile(User user) async {
    try {
      final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final snap = await ref.get();
      if (snap.exists) return;
      final fullName =
          (user.displayName ?? user.email?.split('@').first ?? 'Scholar')
              .trim();
      final parts =
          fullName.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
      await ref.set({
        'id': user.uid,
        'uid': user.uid,
        'firstName': parts.isNotEmpty ? parts.first : fullName,
        'lastName': parts.length > 1 ? parts.sublist(1).join(' ') : '',
        'fullName': fullName,
        'username': fullName,
        'email': user.email ?? '',
        'profilePicture': user.photoURL ?? '',
        'role': 'student',
        'academicLevel': 'STEM',
        'registrationDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) print('Firestore profile backfill failed: $e');
    }
  }

  void screenRedirect() async {
    if (kIsWeb) {
      try {
        await _auth.getRedirectResult();
      } catch (_) {}
    }

    var user = _auth.currentUser;
    if (user == null) {
      try {
        user = await _auth.authStateChanges().first.timeout(
              const Duration(seconds: 2),
              onTimeout: () => _auth.currentUser,
            );
      } catch (_) {}
    }

    if (user != null) {
      try {
        await user.reload();
        user = _auth.currentUser ?? user;
      } catch (_) {}
    }

    if (user != null) {
      await _ensureFirestoreProfile(user);
      Get.offAll(() => const NavigationMenu());
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
        try {
          return await _auth.signInWithPopup(googleProvider);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'popup-blocked' ||
              e.code == 'operation-not-supported-in-this-environment') {
            await _auth.signInWithRedirect(googleProvider);
            return null;
          }
          if (e.code == 'popup-closed-by-user' ||
              e.code == 'cancelled-popup-request') {
            return null;
          }
          rethrow;
        }
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
      if (e.code == 'unauthorized-domain') {
        throw 'This domain is not authorized in Firebase Auth.';
      }
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
