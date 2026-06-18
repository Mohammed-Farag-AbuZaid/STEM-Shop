import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:stem_shop/common/widgets/headings/section_heading.dart';
import 'package:stem_shop/common/widgets/images/rounded_image.dart';
import 'package:stem_shop/common/widgets/product_cart/product_card_horizontal.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(title: Text('Sports'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Banner
              TRoundedContainer(
                width: double.infinity,
                height: 200,
                backgroundColor: TColors.light,
                child: TRoundedImage(
                  imagePath: TImages.shopNow,
                  applyImageRadius: true,
                ),
              ),
              const SizedBox(height: TSizes.spaceBwSections),

              /// Sub-Categories
              Column(
                children: [
                  /// Heading
                  TSectionHeading(title: 'Sports shirts', onPressed: () {}),
                  const SizedBox(height: TSizes.spaceBwItems / 2),

                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: TSizes.spaceBwItems),
                      itemBuilder: (context, index) => const TProductCardHorizontal(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
