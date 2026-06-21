import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/common/widgets/headings/section_heading.dart';
import 'package:stem_shop/features/shop/controllers/products_controler.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/add_to_cart.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/product_images_slider.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/quantity_picker.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/share_button.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';
import 'package:readmore/readmore.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    controller.setActiveProduct(product);

    final isDark = THelperFunctions.isDarkMode(context);

    return Obx(() {
      final current = controller.activeProduct.value ?? product;
      final hasDescription = current.description.trim().isNotEmpty;
      final isAvailable = current.status == 'available' && current.quantity > 0;

      return Scaffold(
        bottomNavigationBar: TBottomAddToCart(product: current),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// product image and carousel
              TProductImageSlider(images: current.images),

              /// product details
              Padding(
                padding: const EdgeInsets.only(
                  right: TSizes.defaultSpace,
                  left: TSizes.defaultSpace,
                  bottom: TSizes.defaultSpace,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShareButton(product: current),

                    ProductMetaData(product: current),

                    /// product description
                    const SizedBox(height: TSizes.spaceBwItems),
                    const TSectionHeading(
                      title: 'Description',
                      showActionButton: false,
                    ),
                    const SizedBox(height: TSizes.sm),
                    TCircularContianer(
                      backgroundColor: TColors.primary.withValues(alpha: 0.05),
                      borderColor: isDark ? TColors.grey : TColors.darkGrey,
                      showBorder: true,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: hasDescription
                            ? ReadMoreText(
                                current.description,
                                style: const TextStyle(fontSize: 12),
                                trimLines: 2,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Read more',
                                trimExpandedText: 'Show less',
                                moreStyle:
                                    const TextStyle(color: Colors.blue, fontSize: 12),
                                lessStyle:
                                    const TextStyle(color: Colors.blue, fontSize: 12),
                              )
                            : const Text(
                                'No description provided.',
                                style: TextStyle(fontSize: 12),
                              ),
                      ),
                    ),

                    /// set order button
                    const SizedBox(height: TSizes.spaceBwSections),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: isAvailable && !controller.placingOrder.value
                            ? () async {
                                final quantity = await QuantityPickerDialog.show(
                                  context,
                                  current.quantity,
                                );
                                if (quantity == null) return;

                                // ignore: use_build_context_synchronously
                                await controller.placeOrder(current, quantity);
                              }
                            : null,
                        child: controller.placingOrder.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(isAvailable ? 'Set Order' : 'Currently Unavailable'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}