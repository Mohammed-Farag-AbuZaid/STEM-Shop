import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:stem_shop/common/widgets/images/rounded_image.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/product_images_slider.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:stem_shop/features/shop/screens/product_details/widgets/share_button.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

