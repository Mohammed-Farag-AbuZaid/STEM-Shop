import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/common/widgets/headings/section_heading.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/add_to_cart.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/product_images_slider.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/share_button.dart';
import 'package:stem_shop/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: TBottomAddToCart(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// product image and carousel
            TProductImageSlider(),

            /// product details
            Padding(
              padding: EdgeInsets.only(
                right: TSizes.defaultSpace,
                left: TSizes.defaultSpace,
                bottom: TSizes.defaultSpace,
              ),
              child: Column(
                children: [
                  /// share button
                  ShareButton(),
                  // --- Rating & Share ---
                  GestureDetector(
                    onTap: () => Get.to(() => const ProductReviewsScreen()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: 4.5,
                              itemSize: 20,
                              unratedColor: TColors.grey,
                              itemBuilder: (context, index) =>
                                  const Icon(Icons.star, color: Colors.amber),
                            ),
                            const SizedBox(width: TSizes.spaceBwItems / 2),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '4.5 ',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                  TextSpan(
                                    text: '(150)',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),

                  /// price, stock and title
                  ProductMetaData(),

                  /// product description
                  SizedBox(height: TSizes.spaceBwItems),
                  TSectionHeading(
                    title: 'Description',
                    showActionButton: false,
                  ),
                  SizedBox(height: TSizes.sm),
                  TCircularContianer(
                    backgroundColor: isDark ? TColors.darkGrey : TColors.grey,
                    borderColor: isDark ? TColors.grey : TColors.darkGrey,
                    showBorder: true,

                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ReadMoreText(
                        style: TextStyle(fontSize: 12),
                        'Product Description the product description the product description the product description the product description the product description the product description the product description the Product Description the product description the product description the product description the product description the product description the product description the Product Description the product description the product description the product description the product description the product description the product description the Product Description the product description the product description the product description the product description the product description the product description the Product Description the product description the product description the product description the product description the product description the product description the Product Description the product description the product description the product description the product description the product description the product description',
                        trimLines: 2,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Read more',
                        trimExpandedText: 'Show less',
                        moreStyle: TextStyle(color: Colors.blue, fontSize: 12),
                        lessStyle: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ),
                  ),

                  /// set order button
                  SizedBox(height: TSizes.spaceBwSections),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Set Order'),
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
