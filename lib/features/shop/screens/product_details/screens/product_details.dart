import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/common/widgets/headings/section_heading.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/add_to_cart.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/product_images_slider.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/share_button.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';
import 'package:readmore/readmore.dart';
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
                    borderColor: isDark ? TColors.grey  : TColors.darkGrey,
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
                        moreStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
                        lessStyle: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                        ),
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
