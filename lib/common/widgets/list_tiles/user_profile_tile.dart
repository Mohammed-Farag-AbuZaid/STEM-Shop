import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/features/personalization/screens/profile/profile.dart';
import 'package:stem_shop/utils/constants/colors.dart';

class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile( // const TCircularImage(image: TImages.user, width: 50, height: 50, padding: 0)
      leading: const CircleAvatar(
                radius: 25, 
                backgroundColor: Colors.grey, 
                child: Icon(Icons.person, color: Colors.white),
              ),
    
      title: Text('Coding with T', style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white)),
      subtitle: Text('support@codingwithT.com', style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.white)),
      trailing: IconButton(onPressed: ()=> Get.to(() => const ProfileScreen()), icon: const Icon(Iconsax.edit, color: TColors.white)),
    );
  }
}