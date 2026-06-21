import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/features/shop/controllers/cart_controller.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TBottomAddToCart extends StatefulWidget {
  const TBottomAddToCart({super.key, required this.product});

  final ProductModel product;

  @override
  State<TBottomAddToCart> createState() => _TBottomAddToCartState();
}

class _TBottomAddToCartState extends State<TBottomAddToCart> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final inStock =
        widget.product.status == 'available' && widget.product.quantity > 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
        vertical: TSizes.sm,
      ),
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
                  color: isDark ? Colors.white : TColors.black,
                  border: Border.all(color: TColors.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Iconsax.minus),
                  onPressed: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                ),
              ),
              const SizedBox(width: TSizes.spaceBwItems),
              Text(
                '$_quantity',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: TSizes.spaceBwItems),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : TColors.white,
                  border: Border.all(color: TColors.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Iconsax.add),
                  onPressed: inStock && _quantity < widget.product.quantity
                      ? () => setState(() => _quantity++)
                      : null,
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: inStock
                ? () {
                    CartController.instance.addProduct(
                      widget.product,
                      quantity: _quantity,
                    );
                    setState(() => _quantity = 1);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(inStock ? 'Add to Cart' : 'Out of Stock'),
          ),
        ],
      ),
    );
  }
}
