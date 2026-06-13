import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TBottomAddToCart extends StatelessWidget {
  const TBottomAddToCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace, vertical: TSizes.sm) ,
      decoration: BoxDecoration(
        color: isDark ? TColors.darkerGrey : TColors.light,
       borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TSizes.cardRadiusLg),
          topRight: Radius.circular(TSizes.cardRadiusLg),
        ),
      ),
      child: Row(
        children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white: TColors.black,
                border: Border.all(color: TColors.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Iconsax.minus),
                onPressed: () {},
              ),

            ),
            const SizedBox(width: TSizes.spaceBwItems),
            Text(
              '1',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: TSizes.spaceBwItems),
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.black: TColors.white,
                border: Border.all(color: TColors.primary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Iconsax.add),
                onPressed: () {},
              ),

            ),
          ]

          )
          ,
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}