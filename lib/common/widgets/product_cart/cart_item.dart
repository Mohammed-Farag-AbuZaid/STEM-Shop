import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/images/rounded_image.dart';
import 'package:stem_shop/common/widgets/texts/product_title.dart';
import 'package:stem_shop/features/shop/controllers/cart_controller.dart';
import 'package:stem_shop/features/shop/models/cart_item_model.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TcartItem extends StatelessWidget {
  const TcartItem({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Image
        TRoundedImage(
          imagePath: item.image.isNotEmpty ? item.image : 'assets/images/content/no_image.png',
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(TSizes.sm),
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? TColors.darkerGrey
              : TColors.light,
        ),
        const SizedBox(width: TSizes.spaceBwItems),

        /// Title & price
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: TProductTitleText(title: item.title)),
              const SizedBox(height: TSizes.xs),
              Text(
                '${item.price.toStringAsFixed(0)} EGP each',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        /// Remove button
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          onPressed: () => CartController.instance.removeItem(item.productId),
        ),
      ],
    );
  }
}