import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stem_shop/data/repositories/authentication_repositrories.dart';
import 'package:stem_shop/utils/helpers/network_manager.dart';
import 'package:stem_shop/utils/popups/full_screen_loader.dart';

class LoginController  extends GetxController {
/// variables
final hidePassword = true.obs;
final rememberMe = true.obs;
final localStorage = GetStorage();
final email = TextEditingController();
final password = TextEditingController();
GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

Future<void> emailAndPasswordLogin() async {
    try {
      TFullScreenLoader.openLoadingDialog('logging you ...', '');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      if (rememberMe.value) {
        localStorage.write('Rememeber_Me_Email', email.text);
        localStorage.write('Rememeber_Me_Password', password.text);
      }

      await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      TFullScreenLoader.stopLoading();

      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      Get.snackbar('Login Failed', e.toString());
    }
  
}}