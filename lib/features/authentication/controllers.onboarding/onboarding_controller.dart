

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stem_shop/features/authentication/loging/login.dart';


class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  /// Page Controller
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  /// update the current page index when the page is changed
  void updatePageIndicator(index) => currentPageIndex.value = index;

  /// Jump to the specific dot selected page.
  void dotNavigationClicked(int index) {
  currentPageIndex.value = index;
  pageController.jumpToPage(index);
}

  /// Function to jump to the next page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      final storage = GetStorage();
      if (kDebugMode) {
        print('======================= GET STORAGE next Button =======================');
        print(storage.read('IsFirstTime'));
      }
      storage.write('IsFirstTime', false);
      Get.offAll(const LoginScreen());
    } else {
      
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }
  /// Function to change the current page index
  void changePageIndex(int index) {
    currentPageIndex.value = index;
  }
  void skipPage() {
    Get.offAll(() => const LoginScreen());
  }
}


