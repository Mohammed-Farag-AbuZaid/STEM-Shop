import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/features/shop/screens/comming_soon/comming_soon.dart';
import 'package:stem_shop/features/shop/screens/product_details/screens/tfunions_info_screen.dart';
import 'package:stem_shop/features/shop/screens/store/store.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';

class TBannerItem {
  final String imagePath;
  final WidgetBuilder pageBuilder;

  const TBannerItem({required this.imagePath, required this.pageBuilder});
}

class HomeController extends GetxController {
  final carouselIndex = 0.obs;

  late final List<TBannerItem> banners;

  @override
  void onInit() {
    super.onInit();

    banners = [
      TBannerItem(
        imagePath: TImages.tfLogo,
        pageBuilder: (context) => const TfUnionsScreen(),
      ),
      TBannerItem(
        imagePath: TImages.shopNow,
        pageBuilder: (context) => const ComingSoonScreen(),
      ),
      TBannerItem(
        imagePath: TImages.request,
        pageBuilder: (context) => const StoreScreen(),
      ),
    ]..shuffle(Random());
  }
}