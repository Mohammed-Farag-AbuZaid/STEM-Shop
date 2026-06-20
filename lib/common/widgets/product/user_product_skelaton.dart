import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';
import 'package:stem_shop/utils/popups/shimmer.dart';

class TMyListingSkeleton extends StatelessWidget {
  const TMyListingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return TCircularContianer(
      showBorder: true,
      borderRadius: 16,
      padding: const EdgeInsets.all(TSizes.md),
      backgroundColor: isDark
          ? TColors.white.withValues(alpha: 0.05)
          : Colors.grey.withValues(alpha: 0.05),
      borderColor: isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.blue.withValues(alpha: 0.1),
      child: Row(
        children: [
          const TShimerEffect(width: 64, height: 64),
          const SizedBox(width: TSizes.spaceBwItems),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                TShimerEffect(width: 120, height: 14),
                SizedBox(height: 8),
                TShimerEffect(width: 70, height: 12),
                SizedBox(height: 8),
                TShimerEffect(width: 90, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}