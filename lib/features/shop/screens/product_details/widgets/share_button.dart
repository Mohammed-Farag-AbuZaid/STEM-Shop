import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hasDiscount =
        product.marketPrice > product.price && product.marketPrice > 0;
    final discountPercent = hasDiscount
        ? (((product.marketPrice - product.price) / product.marketPrice) * 100)
              .round()
        : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (hasDiscount) ...[
              TCircularContianer(
                borderRadius: TSizes.sm,
                backgroundColor: TColors.secondry.withValues(alpha: 0.8),
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm,
                  vertical: TSizes.xs,
                ),
                child: Text(
                  '$discountPercent%',
                  style: Theme.of(context).textTheme.labelLarge!.apply(
                    color: isDark ? TColors.secondry : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: TSizes.sm),
              Stack(
                children: [
                  Text(
                    'EGP ${product.marketPrice.toStringAsFixed(0)} ',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isDark ? TColors.grey : TColors.darkGrey,
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    right: 3,
                    child: Container(height: 2, width: 25, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(width: TSizes.sm),
            ],
            Text(
              'EGP ${product.price.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
      ],
    );
  }
}
