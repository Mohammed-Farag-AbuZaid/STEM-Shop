import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stem_shop/data/repositories/authentication_repositrories.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/utils/helpers/network_manager.dart';
import 'package:stem_shop/utils/popups/full_screen_loader.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class LoginController extends GetxController {
  final hidePassword = true.obs;
  final rememberMe = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.find<UserController>();

  @override
  void onInit() {
    super.onInit();
    email.text = localStorage.read('Remember_Me_Email') ?? '';
  }

  Future<void> emailAndPasswordLogin() async {
    try {
      TFuelScreenLoader.openLoadingDialog(
        'Logging in...',
        'assets/images/loading.json',
      );

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFuelScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'No Connection',
          message: 'Please check your internet connection.',
        );
        return;
      }

      if (!loginFormKey.currentState!.validate()) {
        TFuelScreenLoader.stopLoading();
        return;
      }

      if (rememberMe.value) {
        localStorage.write('Remember_Me_Email', email.text.trim());
      }

      await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      TFuelScreenLoader.stopLoading();
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFuelScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Login Failed', message: e.toString());
    }
  }

  Future<void> googleLogin() async {
    try {
      TFuelScreenLoader.openLoadingDialog(
        'Signing in with Google...',
        'assets/images/loading.json',
      );

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFuelScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'No Connection',
          message: 'Please check your internet connection.',
        );
        return;
      }
      final userCredentials = await AuthenticationRepository.instance
          .signInWithGoogle();

      // Save User Record
      await userController.saveUserRecord(userCredentials);

      // Remove Loader
      TFuelScreenLoader.stopLoading();
      // Redirect to the appropriate screen
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFuelScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Login Failed', message: e.toString());
    }
  }
}
