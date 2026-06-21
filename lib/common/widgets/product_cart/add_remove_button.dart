import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/features/shop/controllers/cart_controller.dart';
import 'package:stem_shop/features/shop/models/cart_item_model.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TProductQuantityWithAddRemoveButton extends StatelessWidget {
  const TProductQuantityWithAddRemoveButton({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final cart = CartController.instance;

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.white : TColors.black,
            border: Border.all(color: TColors.primary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Iconsax.minus),
            onPressed: () => cart.updateQuantity(item.productId, item.quantity - 1),
          ),
        ),
        const SizedBox(width: TSizes.spaceBwItems),
        Text('${item.quantity}', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(width: TSizes.spaceBwItems),
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.black : TColors.white,
            border: Border.all(color: TColors.primary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Iconsax.add),
            onPressed: item.quantity < item.maxQuantity
                ? () => cart.updateQuantity(item.productId, item.quantity + 1)
                : null,
          ),
        ),
      ],
    );
  }
}