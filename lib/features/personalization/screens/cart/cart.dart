import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/icons/t_circular_icon.dart';
import 'package:stem_shop/common/widgets/product_cart/cart_item.dart';
import 'package:stem_shop/common/widgets/product_cart/add_remove_button.dart';
import 'package:stem_shop/common/widgets/texts/product_price_text.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: 10,
          separatorBuilder: (_, __) =>
              const SizedBox(height: TSizes.spaceBwSections),
          itemBuilder: (_, index) => Column(
            children: [
              const TcartItem(),
              const SizedBox(height: TSizes.spaceBwItems),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      /// Extra Space
                      const SizedBox(width: 70),

                      /// Add Remove Buttons
                      const TProductQuantityWithAddRemoveButton(),
                    ],
                  ),

                  /// -- Product total price
                  TProductPriceText(price: '256'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () {},
          child: const Text('Order Now \$256.0'),
        ),
      ),
    );
  }
}
