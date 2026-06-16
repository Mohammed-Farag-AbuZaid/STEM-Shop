import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/personalization/screens/profile/profile.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/popups/shimmer.dart';

class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return ListTile(
      // const TCircularImage(image: TImages.user, width: 50, height: 50, padding: 0)
      leading: const CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, color: Colors.white),
      ),

      title: Obx(() {
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
      subtitle: Obx(() {
        if (controller.profileLoading.value) {
          return const TShimerEffect(width: 150, height: 20);
        } else {
          return Text(
            controller.user.value.username,
            style: Theme.of(
              context,
            ).textTheme.labelSmall!.apply(color: TColors.white),
          );
        }
      }),
      trailing: IconButton(
        onPressed: () => Get.to(() => const ProfileScreen()),
        icon: const Icon(Iconsax.edit, color: TColors.white),
      ),
    );
  }
}
