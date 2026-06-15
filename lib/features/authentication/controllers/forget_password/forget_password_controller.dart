import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/data/repositories/authentication_repositrories.dart';
import 'package:stem_shop/features/authentication/screens/password_configrations/reset_password.dart';
import 'package:stem_shop/utils/helpers/network_manager.dart';
import 'package:stem_shop/utils/popups/full_screen_loader.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();

  final GlobalKey<FormState> forgetPasswordFormKey =
      GlobalKey<FormState>();

  /// Send Reset Password Email
  Future<void> sendPasswordResetEmail() async {
    try {
      TFuelScreenLoader.openLoadingDialog(
        'Sending password reset email...',
        'assets/images/loading.json',
      );

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFuelScreenLoader.stopLoading();

        TLoaders.warningSnackBar(
          title: 'No Connection',
          message: 'Please check your internet connection.',
        );

        return;
      }

      // Form Validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        TFuelScreenLoader.stopLoading();
        return;
      }

      final userEmail = email.text.trim();

      // Send Reset Email
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(userEmail);

      TFuelScreenLoader.stopLoading();

      TLoaders.warningSnackBar(
        title: 'Reset Password',
        message:
            'A password reset email has been sent to $userEmail. Please check your inbox.',
      );

      Get.to(
        () => ResetPassword(
          email: userEmail,
        ),
      );
    } catch (e) {
      TFuelScreenLoader.stopLoading();

      TLoaders.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  /// Resend Reset Password Email
  Future<void> resendPasswordResetEmail(String email) async {
    try {
      TFuelScreenLoader.openLoadingDialog(
        'Sending password reset email...',
        'assets/images/loading.json',
      );

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFuelScreenLoader.stopLoading();

        TLoaders.warningSnackBar(
          title: 'No Connection',
          message: 'Please check your internet connection.',
        );

        return;
      }

      // Send Reset Email
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email);

      TFuelScreenLoader.stopLoading();

      TLoaders.warningSnackBar(
        title: 'Reset Password',
        message:
            'A password reset email has been sent to $email. Please check your inbox.',
      );
    } catch (e) {
      TFuelScreenLoader.stopLoading();

      TLoaders.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  @override
  void onClose() {
    email.dispose();
    super.onClose();
  }
}