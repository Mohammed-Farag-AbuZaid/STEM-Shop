import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/headings/section_heading.dart';
import 'package:stem_shop/common/widgets/layouts/grid_layout.dart';
import 'package:stem_shop/common/widgets/product/product_card_vertical.dart';
import 'package:stem_shop/features/shop/models/category_model.dart';
import 'package:stem_shop/features/shop/screens/store/sub_category_showcase.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class TCategoryShowcase extends StatelessWidget {
  const TCategoryShowcase({
    super.key,
    required this.category,
  });

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
             
            TSubCategoryShowcase(
              images: [TImages.google, TImages.google, TImages.google],
            ),
            const SizedBox(height: TSizes.spaceBwItems),
            TSectionHeading(title: 'Suggested Items', onPressed: () {}, showActionButton: true),
            const SizedBox(height: TSizes.spaceBwItems),
            TGridLayout(itemCount: 6, itemBuilder: (_, index) => TProductCardVertical())
          ],
        ),
      
      ),
      ]
    );
  }
}

