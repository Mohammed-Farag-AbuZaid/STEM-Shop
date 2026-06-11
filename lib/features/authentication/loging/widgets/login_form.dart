import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/features/authentication/screens/password_configrations/forget_password.dart';
import 'package:stem_shop/navigation_menu.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/constants/text_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBwSections),
        child: Column(
          children: [
            // Email
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: TSizes.spaceBwInputFields),

            // Password
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: Icon(Iconsax.eye_slash),
              ),
            ),
            const SizedBox(height: TSizes.spaceBwInputFields / 2),

            // Remember Me & Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text("Remember me"),
                  ],
                ),
                TextButton(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  child: const Text("Forgot password?"),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBwSections),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const NavigationMenu()),
                child: Text(TTexts.signIn),
              ),
            ),

            const SizedBox(height: TSizes.spaceBwItems),

            // Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  final Uri url = Uri.parse(
                    "https://tf-unions.netlify.app/#homePage",
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: const Text("Create a TF account."),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
