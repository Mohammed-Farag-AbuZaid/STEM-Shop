import "package:flutter/material.dart";
import "package:iconsax/iconsax.dart";
import "package:stem_shop/common/styles/spacing_styles.dart";
import "package:stem_shop/utils/constants/colors.dart";
import "package:stem_shop/utils/constants/image_strings.dart";
import "package:stem_shop/utils/constants/sizes.dart";
import "package:stem_shop/utils/constants/text_strings.dart";
import "package:stem_shop/utils/helpers/helper_functions.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHieght,
          child: Column(
            children: [
              /// logo and title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    height: 150,
                    image: AssetImage(
                      dark ? TImages.darkAppLogo : TImages.lightAppLogo,
                    ),
                  ),

                  Text(
                    TTexts.loginTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: TSizes.sm),
                  Text(
                    TTexts.loginSubTitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBwSections),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: TSizes.sm),
                      SizedBox(height: TSizes.spaceBwInputFields),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Iconsax.password_check),
                          suffixIcon: Icon(Iconsax.eye_slash),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBwInputFields / 2),
                  
                      // remember me and forgot password
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
                            onPressed: () {},
                            child: const Text("Forgot password?"),
                          ),
                  
                          SizedBox(height: TSizes.spaceBwSections),
                  
                          // sign in button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text("Sign In"),
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBwItems),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text("Create a TF account "),
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBwSections),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider( color: dark ? TColors.darkGrey : TColors.grey, thickness: 0.5, indent: 60, endIndent: 5,)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                    child: Text(
                      "Or continue with",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
