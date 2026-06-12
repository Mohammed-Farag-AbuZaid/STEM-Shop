import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/common/widgets/images/rounded_image.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TCategoryCard extends StatelessWidget {
  const TCategoryCard({
    super.key,
    this.onTap,
    required this.showBorder,
  });

  final VoidCallback? onTap;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: TCircularContianer(
        showBorder: showBorder,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(TSizes.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: TRoundedImage(
                isNetworkImage: false,
                backgroundColor: Colors.transparent, 
                imagePath: TImages.google,
              ),
            ),
            const SizedBox(width: TSizes.spaceBwItems / 2),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category Name', style: Theme.of(context).textTheme.bodyMedium),
                  Text('20 products', style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
