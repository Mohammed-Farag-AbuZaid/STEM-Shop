import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/features/personalization/controllers/update_phone_controller.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/validators/validation.dart';

class ChangePhone extends StatelessWidget {
  const ChangePhone({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdatePhoneController());

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Change Phone',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: controller.updateUserPhoneFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please enter a valid WhatsApp number. This will be used for orders and notifications.',
                style: Theme.of(context).textTheme.labelMedium,
              ),

              const SizedBox(height: TSizes.spaceBwSections),

              TextFormField(
                controller: controller.phone,
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    TValidator.validatePhoneNumber(value),
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Iconsax.call),
                ),
              ),

              const SizedBox(height: TSizes.spaceBwSections),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.updateUserPhone(),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}