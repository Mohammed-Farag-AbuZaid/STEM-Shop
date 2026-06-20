import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/common/widgets/images/rounded_image.dart';
import 'package:stem_shop/common/widgets/menues/product_action_menu.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TMyListingCard extends StatelessWidget {
  const TMyListingCard({
    super.key,
    required this.product,
    required this.onAction,
  });

  final ProductModel product;
  final void Function(TProductAction action) onAction;

  Color _statusColor() {
    if (product.status == 'hidden') return Colors.grey;
    if (product.status == 'sold' || product.quantity == 0) return Colors.red;
    return Colors.green;
  }

  String _statusLabel() {
    if (product.status == 'hidden') return 'Hidden';
    if (product.status == 'sold' || product.quantity == 0) return 'Sold Out';
    return '${product.quantity} remaining';
  }

  IconData _statusIcon() {
    if (product.status == 'hidden') return Icons.visibility_off_outlined;
    if (product.status == 'sold' || product.quantity == 0) {
      return Icons.check_circle_outline;
    }
    return Icons.storefront_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final imagePath =
        product.thumbnail.isNotEmpty ? product.thumbnail : TImages.shopNow;

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
          TRoundedImage(
            imagePath: imagePath,
            width: 64,
            height: 64,
            applyImageRadius: true,
          ),
          const SizedBox(width: TSizes.spaceBwItems),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'EGP ${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(_statusIcon(), size: 13, color: _statusColor()),
                    const SizedBox(width: 4),
                    Text(
                      _statusLabel(),
                      style: TextStyle(
                        fontSize: 12,
                        color: _statusColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TProductActionsMenu(product: product, onAction: onAction),
        ],
      ),
    );
  }
}