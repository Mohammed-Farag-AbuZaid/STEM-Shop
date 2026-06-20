import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/images/circular_image.dart';
import 'package:stem_shop/data/repositories/user/user_model.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class SellerInfoDialog extends StatelessWidget {
  const SellerInfoDialog({super.key, required this.seller});

  final UserModel seller;

  static void show(BuildContext context, UserModel seller) {
    showDialog(
      context: context,
      builder: (_) => SellerInfoDialog(seller: seller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Dialog(
      backgroundColor: isDark ? TColors.dark : TColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TCircularImage(
              imagePath: seller.profilePicture.isNotEmpty
                  ? seller.profilePicture
                  : 'assets/images/content/user.png',
              isNetworkImage: seller.profilePicture.isNotEmpty,
              width: 90,
              height: 90, 
            ),
            const SizedBox(height: TSizes.spaceBwItems),
            Text(
              seller.fullName.trim().isNotEmpty ? seller.fullName : 'Unknown Seller',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.sm),
            if (seller.grade.isNotEmpty)
              Text('Grade: ${seller.grade}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: TSizes.sm),
            if (seller.phone.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone, size: 16),
                  const SizedBox(width: TSizes.xs),
                  Text(seller.formattedPhoneNo, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            const SizedBox(height: TSizes.spaceBwItems),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}