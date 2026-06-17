import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/images/circular_image.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/personalization/screens/profile/profile.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/popups/shimmer.dart';

class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return ListTile(
      // const TCircularImage(image: TImages.user, width: 50, height: 50, padding: 0)
      leading: SizedBox(
        width: 60,
        height: 60,
        child: Obx(() {
          final networkImage = controller.user.value.profilePicture;
          final image = networkImage.isNotEmpty ? networkImage : TImages.user;
          return controller.imageUploading.value
              ? TShimerEffect(width: 80, height: 80, radius: 80)
              : TCircularImage(
                  width: 80,
                  height: 80,
                  isNetworkImage: networkImage.isNotEmpty,
                  imagePath: image,
                );
        }),
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
