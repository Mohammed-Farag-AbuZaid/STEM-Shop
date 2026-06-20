import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/shadows.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';
import 'package:stem_shop/utils/popups/shimmer.dart';

class TProductCardSkeleton extends StatelessWidget {
  const TProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Container(
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
          const TShimerEffect(width: 170, height: 150),
          const SizedBox(height: TSizes.spaceBwItems),
          const Padding(
            padding: EdgeInsets.only(left: TSizes.sm),
            child: TShimerEffect(width: 140, height: 15),
          ),
          const SizedBox(height: TSizes.xs),
          const Padding(
            padding: EdgeInsets.only(left: TSizes.sm),
            child: TShimerEffect(width: 100, height: 12),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(left: TSizes.sm, bottom: TSizes.sm),
            child: TShimerEffect(width: 60, height: 15),
          ),
        ],
      ),
    );
  }
}