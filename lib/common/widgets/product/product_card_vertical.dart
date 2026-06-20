import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/shadows.dart';
import 'package:stem_shop/common/widgets/images/rounded_image.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/features/shop/screens/product_details/screens/product_details.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({super.key, this.product});

  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    final bool isDark = THelperFunctions.isDarkMode(context);

    // Use real data if product is provided, fall back to placeholders
    final title = product?.title ?? 'Product Name';
    final description = product?.description ?? 'Description of the product';
    final price = product != null ? 'EGP ${product!.price.toStringAsFixed(0)}' : '\$100';
    final isNetworkImage = product?.thumbnail.isNotEmpty ?? false;
    final imagePath = isNetworkImage ? product!.thumbnail : TImages.shopNow;

    return GestureDetector(
      onTap: product != null
    ? () => Get.to(() => ProductDetailsScreen(product: product!))
    : null,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(5),
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
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: isDark ? TColors.dark : TColors.light,
              borderRadius: TSizes.productImageRadius,
              child: Stack(
                children: [
                  TRoundedImage(
                    imagePath: imagePath,
                    isNetworkImage: isNetworkImage,
                    applyImageRadius: true,
                  ),
                  // Condition badge — 'new', 'like_new', 'used'
                  if (product != null)
                    Positioned(
                      top: 9,
                      left: 9,
                      child: TCircularContianer(
                        backgroundColor: TColors.secondry.withValues(alpha: 0.8),
                        borderRadius: TSizes.productImageRadius,
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.sm,
                          vertical: TSizes.xs,
                        ),
                        child: Text(
                          product!.condition == 'new'
                              ? 'New'
                              : product!.condition == 'like_new'
                                  ? 'Like New'
                                  : 'Used',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .apply(color: TColors.black),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBwItems),
            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm, top: TSizes.xs),
              child: Text(
                description,
                style: Theme.of(context).textTheme.labelMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
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
                    child: const Center(
                      child: Icon(Iconsax.add, color: TColors.white),
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