import 'package:get/get.dart';
import 'package:stem_shop/data/repositories/authentication_repositrories.dart';
import 'package:stem_shop/utils/helpers/network_manager.dart';
import 'package:stem_shop/utils/popups/full_screen_loader.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class EmailVerificationController extends GetxController {
  static EmailVerificationController get instance => Get.find();

  /// Resend Email Verification Email
  Future<void> resendEmailVerificationEmail(String email) async {
    try {
      TFuelScreenLoader.openLoadingDialog(
        'Sending verification email...',
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

      await AuthenticationRepository.instance.sendEmailVerification();

      TFuelScreenLoader.stopLoading();

      TLoaders.warningSnackBar(
        title: 'Email Verification',
        message:
            'A verification email has been sent to $email. Please check your inbox.',
      );
    } catch (e) {
      TFuelScreenLoader.stopLoading();

      TLoaders.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

}