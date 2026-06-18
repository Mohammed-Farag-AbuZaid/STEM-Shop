import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/features/shop/models/category_model.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TSubCategoryCard extends StatelessWidget {
  const TSubCategoryCard({
    super.key,
    required this.subCategory,
    required this.images, required bool showBorder,
  });

  final CategoryModel subCategory;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return TCircularContianer(
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(TSizes.sm),
      margin: const EdgeInsets.only(bottom: TSizes.spaceBwItems),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subCategory.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('View All'),
              ),
            ],
          ),
          Row(
            children: images
                .map((image) => _productImageWidget(image, context))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _productImageWidget(String image, BuildContext context) {
    return Expanded(
      child: TCircularContianer(
        height: 100,
        backgroundColor: THelperFunctions.isDarkMode(context)
            ? TColors.darkerGrey
            : TColors.light,
        borderColor: TColors.borderPrimary,
        margin: const EdgeInsets.only(right: TSizes.sm),
        padding: const EdgeInsets.all(TSizes.md),
        child: Image(fit: BoxFit.contain, image: AssetImage(image)),
      ),
    );
  }
}