
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    final ctx = Get.overlayContext ?? Get.context;
    if (ctx == null) return;

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: THelperFunctions.isDarkMode(Get.context!) ? TColors.dark : TColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 250),
              // Fallback simple loader when custom animation widget is not available
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(text, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void stopLoading(){
    Navigator.of(Get.overlayContext!).pop();
  }
}