import "package:flutter/material.dart";
import "package:get/get_core/src/get_main.dart";
import "package:get/get_navigation/src/extension_navigation.dart";
import "package:stem_shop/common/styles/spacing_styles.dart";
import "package:stem_shop/features/authentication/loging/login.dart";
import "package:stem_shop/utils/constants/sizes.dart";
import "package:stem_shop/utils/helpers/helper_functions.dart";

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.title,
    required this.image,
    required this.subtitle,
    required this.onPressed,
  });

  final String title, image, subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHieght * 2,

          child: Column(children: [
            Image(
              image: AssetImage( image ),
              width: THelperFunctions.screenWidth() * 0.6,
            ),
            SizedBox(height: TSizes.spaceBwSections),

            /// Title and Subtitle
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: TSizes.spaceBwSections),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: TSizes.spaceBwSections * 2),
            /// Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const LoginScreen()),
                
                child: const Text("Continue"),
              ),
            ),
          ],),
          ),
      ),
    );
  }
}
