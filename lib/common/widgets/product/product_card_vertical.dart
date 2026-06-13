import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/shadows.dart';
import 'package:stem_shop/common/widgets/images/rounded_image.dart';
import 'package:stem_shop/features/shop/screens/product_details/screens/product_details.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailsScreen()),
      child: Container(
        width: 180,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          boxShadow: [TShadowStyle.verticalProductShadow],
          color: isDark ? TColors.darkGrey : TColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TCircularContianer(
              height: 150,
              padding: EdgeInsets.all(TSizes.sm),
              backgroundColor: isDark ? TColors.dark : TColors.light,
              borderRadius: TSizes.productImageRadius,
              child: Stack(
                children: [
                  TRoundedImage(
                    imagePath: TImages.darkDigital,
                    applyImageRadius: true,
                  ),
                  Positioned(
                    top: 9,
                    left: 9,
                    child: TCircularContianer(
                      backgroundColor: TColors.secondry.withValues(alpha: 0.8),
                      borderRadius: TSizes.productImageRadius,
                      padding: EdgeInsets.symmetric(
                        horizontal: TSizes.sm,
                        vertical: TSizes.xs,
                      ),
                      child: Text(
                        "20%",
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge!.apply(color: TColors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: TSizes.spaceBwItems),
            Padding(
              padding: EdgeInsets.only(left: TSizes.sm),
              child: Text(
                "Product Name",
                style: Theme.of(context).textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.start,
              ),),
            Padding(
              padding: EdgeInsets.only(left: TSizes.sm, top: TSizes.xs),
              child: Text('description of the product, here should be a longer description', style: Theme.of(context).textTheme.labelMedium, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,)
            )
            ,
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$100",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                Container(
                  decoration: BoxDecoration(
                    color: TColors.dark,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(TSizes.cardRadiusMd),
                      bottomRight: Radius.circular(TSizes.productImageRadius),
                    ),
                  ),
                  child: SizedBox(
                    width: TSizes.iconLg * 1.2,
                    height: TSizes.iconLg * 1.2,
                    child: Center(
                      child: const Icon(Iconsax.add, color: TColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
