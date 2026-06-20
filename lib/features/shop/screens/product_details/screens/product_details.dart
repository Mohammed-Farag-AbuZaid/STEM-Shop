import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/common/widgets/headings/section_heading.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/add_to_cart.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/product_images_slider.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/product_meta_data.dart';
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
    final isDark = THelperFunctions.isDarkMode(context);
    final hasDescription = product.description.trim().isNotEmpty;

    return Scaffold(
      bottomNavigationBar: const TBottomAddToCart(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// product image and carousel
            TProductImageSlider(images: product.images),

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
                  /// share button
                  ShareButton(product: product),

                  /// price, status and title
                  ProductMetaData(product: product),

                  /// product description
                  const SizedBox(height: TSizes.spaceBwItems),
                  const TSectionHeading(
                    title: 'Description',
                    showActionButton: false,
                  ),
                  const SizedBox(height: TSizes.sm),
                  TCircularContianer(
                    backgroundColor: isDark ? TColors.darkGrey : TColors.grey,
                    borderColor: isDark ? TColors.grey : TColors.darkGrey,
                    showBorder: true,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: hasDescription
                          ? ReadMoreText(
                              product.description,
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
                    height: 50,
                    child: ElevatedButton(
                      onPressed: product.status == 'available' ? () {} : null,
                      child: Text(
                        product.status == 'available'
                            ? 'Set Order'
                            : 'Currently Unavailable',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}