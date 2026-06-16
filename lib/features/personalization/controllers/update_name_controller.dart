import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/data/repositories/user/user_repository.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/helpers/network_manager.dart';
import 'package:stem_shop/utils/popups/full_screen_loader.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initializeNames();
  }

  Future<void> initializeNames() async {
    firstName.text = userController.user.value.firstName;
    lastName.text = userController.user.value.lastName;
  }

  Future<void> updateUserName() async {
    try {
      TFuelScreenLoader.openLoadingDialog(
        'Updating name...',
        TImages.loading,
      );

      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        TFuelScreenLoader.stopLoading();
        return;
      }

      // Validate Form
      if (!updateUserNameFormKey.currentState!.validate()) {
        TFuelScreenLoader.stopLoading();
        return;
      }

      final trimmedFirstName = firstName.text.trim();
      final trimmedLastName = lastName.text.trim();

      Map<String, dynamic> name = {
        'firstName': trimmedFirstName,
        'lastName': trimmedLastName,
      };

      await userRepository.updateSingleField(name);

      userController.user.value = userController.user.value.copyWith(
        firstName: trimmedFirstName,
        lastName: trimmedLastName,
      );

      TFuelScreenLoader.stopLoading();
      Get.back();
      TLoaders.successSnackBar(
        title: 'Congrats',
        message: 'Your name has been updated successfully',
      );

      Get.back();
    } catch (e) {
      TFuelScreenLoader.stopLoading();

      TLoaders.errorSnackBar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }
}