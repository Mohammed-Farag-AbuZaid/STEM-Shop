import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/data/repositories/user/user_repository.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/personalization/screens/profile/profile.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/helpers/network_manager.dart';
import 'package:stem_shop/utils/popups/full_screen_loader.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class UpdatePhoneController extends GetxController {
  static UpdatePhoneController get instance => Get.find();

  final phone = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserPhoneFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initializePhone();

  }

  Future<void> initializePhone() async {
    phone.text = userController.user.value.phone;
  }

  Future<void> updateUserPhone() async {
  try {
    TFuelScreenLoader.openLoadingDialog(
      'Updating phone...',
      TImages.loading,
    );

    final isConnected = await NetworkManager.instance.isConnected();

    if (!isConnected) {
      TFuelScreenLoader.stopLoading();
      return;
    }

    // Validate form
    if (!updateUserPhoneFormKey.currentState!.validate()) {
      TFuelScreenLoader.stopLoading();
      return;
    }

    Map<String, dynamic> phoneData = {
      'phone': phone.text.trim(),
    };

    await userRepository.updateSingleField(phoneData);

    userController.user.value.phone = phone.text.trim();

    TFuelScreenLoader.stopLoading();

    TLoaders.successSnackBar(
      title: 'Congrats',
      message: 'Your phone number has been updated successfully',
    );

    Get.off(() => const ProfileScreen());
  } catch (e) {
    TFuelScreenLoader.stopLoading();

    TLoaders.errorSnackBar(
      title: 'Error',
      message: e.toString(),
    );
  }
}
}


