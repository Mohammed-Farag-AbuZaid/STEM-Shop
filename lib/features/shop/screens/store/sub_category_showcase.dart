import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/features/shop/screens/store/sub_category_card.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TSubCategoryShowcase extends StatelessWidget {
  const TSubCategoryShowcase({super.key, required this.images});
  final List<String> images;
  @override
  Widget build(BuildContext context) {
    return TCircularContianer(
      showBorder: true,
      backgroundColor: Colors.transparent,
      borderColor: TColors.borderPrimary,
      padding: const EdgeInsets.all(TSizes.sm),
      margin: const EdgeInsets.only(bottom: TSizes.spaceBwItems),

      child: Column(
        children: [
          TCategoryCard(showBorder: false),
            const SizedBox(height: TSizes.spaceBwItems),

          Row(
            children: [
              ...images.map((image) => brandTopProdutsImageWidget(image, context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget brandTopProdutsImageWidget(String image, context) {
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
