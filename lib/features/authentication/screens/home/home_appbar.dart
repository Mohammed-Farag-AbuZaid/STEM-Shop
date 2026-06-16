import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/product_cart/cart_menu_icon.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/popups/shimmer.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (controller.profileLoading.value) {
              return const TShimerEffect(width: 150, height: 20);
            } else {
              return Text(
                controller.user.value.fullName,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall!.apply(color: TColors.white),
              );
            }
          }),
          Obx(() {
            if (controller.profileLoading.value) {
              return const TShimerEffect(width: 80, height: 15);
            } else {
              return Text(
                controller.user.value.stemSchool,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall!.apply(color: TColors.grey),
              );
            }
          }),
        ],
      ),
      actions: [
        TCartCounterIcon(
          iconColor: TColors.white,
          counterBgColor: Colors.black,
          counterTextColor: Colors.white,
          onPressed: () {},
        ),
      ],
    );
  }
}
