import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/common/widgets/images/rounded_image.dart';
import 'package:stem_shop/features/shop/controllers/home_page_controller.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class TPromoSlider extends StatelessWidget {
  const TPromoSlider({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1.06,
            onPageChanged: (index, _) => controller.carouselIndex.value = index,
          ),
          items: controller.banners.map((banner) {
            return GestureDetector(
              onTap: () => Get.to(banner.pageBuilder(context)),
              child: TRoundedImage(imagePath: banner.imagePath),
            );
          }).toList(),
        ),
        const SizedBox(height: TSizes.spaceBwItems),

        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < controller.banners.length; i++)
                TCircularContianer(
                  width: 20,
                  height: 4,
                  backgroundColor: controller.carouselIndex.value == i
                      ? TColors.primary
                      : Colors.grey,
                  margin: const EdgeInsets.only(right: 10),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
