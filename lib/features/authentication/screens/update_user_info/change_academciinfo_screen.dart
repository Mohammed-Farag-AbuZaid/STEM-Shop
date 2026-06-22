import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/buttons/visit_tf_button.dart';
import 'package:stem_shop/features/authentication/loging/login.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class ChangeAcademicInfo extends StatelessWidget {
  const ChangeAcademicInfo({super.key, this.showBackArrow = true, this.fullMessage = true, this.title = 'Change Academic Info', this.description = 'This action cannot be done from here, you can change your Academic Info from the TF-Unions website'});

  final String title;
  final String description;
  final bool fullMessage;
  final bool showBackArrow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: showBackArrow,
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fullMessage
                  ? 'This action cannot be done from here, you can change your $description and all other Academic Info from the TF-Unions website'
                  : description,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: TSizes.spaceBwSections),


            VisitTFButton(),
            SizedBox(height: TSizes.spaceBwSections),
            if (!fullMessage)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAll(() => const LoginScreen()),
                  child: const Text('or login with another account'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


