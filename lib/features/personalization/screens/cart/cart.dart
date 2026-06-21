import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/product_cart/cart_item.dart';
import 'package:stem_shop/common/widgets/product_cart/add_remove_button.dart';
import 'package:stem_shop/common/widgets/texts/product_price_text.dart';
import 'package:stem_shop/features/personalization/screens/cart/checkout_screen.dart';
import 'package:stem_shop/features/shop/controllers/cart_controller.dart';
import 'package:stem_shop/features/shop/controllers/checkout_controller.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartController.instance;
    final checkout = Get.put(CheckoutController());

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Obx(() {
        if (cart.isEmpty) {
          return const Center(child: Text('Your cart is empty.'));
        }

        final grouped = cart.groupedBySeller;
        final sellerIds = grouped.keys.toList();

        return ListView.separated(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          itemCount: sellerIds.length,
          separatorBuilder: (_, _) =>
              const SizedBox(height: TSizes.spaceBwSections),
          itemBuilder: (_, sellerIndex) {
            final sellerItems = grouped[sellerIds[sellerIndex]]!;
            final sellerSubtotal = sellerItems.fold(
              0.0,
              (sum, item) => sum + item.totalPrice,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...sellerItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: TSizes.spaceBwItems),
                    child: Column(
                      children: [
                        TcartItem(item: item),
                        const SizedBox(height: TSizes.spaceBwItems),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 70),
                                TProductQuantityWithAddRemoveButton(item: item),
                              ],
                            ),
                            TProductPriceText(
                              price: item.totalPrice.toStringAsFixed(0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Seller subtotal: ${sellerSubtotal.toStringAsFixed(0)} EGP',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        if (cart.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: ElevatedButton(
            onPressed: checkout.isProcessing.value
                ? null
                : () async {
                    final success = await checkout.checkoutCart();
                    if (success) {
                      // ignore: use_build_context_synchronously
                      Get.to(() => const CheckoutResultsScreen());
                    }
                  },
            child: checkout.isProcessing.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Order Now \u2014 ${cart.totalPrice.toStringAsFixed(0)} EGP',
                  ),
          ),
        );
      }),
    );
  }
}
