import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/texts/section_heading.dart';
import 'package:stem_shop/features/authentication/screens/update_user_info/change_academciinfo_screen.dart';
import 'package:stem_shop/features/authentication/screens/update_user_info/change_name_screen.dart';
import 'package:stem_shop/features/authentication/screens/update_user_info/change_phone_screen.dart';
import 'package:stem_shop/features/authentication/screens/update_user_info/change_school_screen.dart';
import 'package:stem_shop/features/authentication/screens/update_user_info/change_grade_screen.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: const TAppBar(showBackArrow: true, title: Text('Profile')),

      /// -- Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    // const TCircularImage(image: TImages.user, width: 80, height: 80),
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Change Profile Picture'),
                    ),
                  ],
                ),
              ),

              /// /// Details
              const SizedBox(height: TSizes.spaceBwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBwItems),

              /// /// Heading Profile Info
              const TSectionHeading(
                title: 'Profile Information',
                showActionButton: false,
              ),
              const SizedBox(height: TSizes.spaceBwItems),

              TProfileMenu(
                title: "Name",
                value: controller.user.value.fullName,
                onPressed: () => Get.to(() => const ChangeName()),
              ),
              TProfileMenu(
                title: 'Grade',
                value: controller.user.value.grade,
                onPressed: () => Get.to(() => const ChangeAcademicInfo(title: 'Change Grade', description: 'Grade')),
              ),
              TProfileMenu(
                title: 'School',
                value: controller.user.value.stemSchool,
                onPressed: () => Get.to(() => const ChangeAcademicInfo(title: 'Change School', description: 'School')),
              ),
              TProfileMenu(
                title: 'Gender',
                value: controller.user.value.gender,
                onPressed: () {},
                icon: Iconsax.happyemoji2
              ),
              TProfileMenu(
                title: 'Whatsapp Number',
                value: controller.user.value.phone,
                onPressed: () => Get.to(() => const ChangePhone()),
              ),

              const SizedBox(height: TSizes.spaceBwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBwItems),

              /// /// Heading Profile Info

              /// /// Heading Personal Info
              const TSectionHeading(
                title: 'Personal Information',
                showActionButton: false,
              ),
              const SizedBox(height: TSizes.spaceBwItems),

              TProfileMenu(
                title: 'E-mail',
                value: controller.user.value.email,
                icon: Iconsax.copy,
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: controller.user.value.email),
                  );

                  TLoaders.successSnackBar(
                    title: 'Copied',
                    message: 'E-mail has been copied to clipboard',
                  );
                },
              ),
              TProfileMenu(
                title: 'Birth Date',
                value: controller.user.value.birthDate,
                icon: Iconsax.copy,
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: controller.user.value.birthDate),
                  );

                  TLoaders.successSnackBar(
                    title: 'Copied',
                    message: 'Birth date has been copied to clipboard',
                  );
                },
              ),
              TProfileMenu(
                title: 'User ID',
                value: controller.user.value.id,
                icon: Iconsax.copy,
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: controller.user.value.id),
                  );

                 TLoaders.successSnackBar(
                    title: 'Copied',
                    message: 'User ID has been copied to clipboard',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
