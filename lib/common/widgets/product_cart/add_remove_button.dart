import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/icons/t_circular_icon.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class   TProductQuantityWithAddRemoveButton extends StatelessWidget {
  const TProductQuantityWithAddRemoveButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TCircularIcon(
          icon: Iconsax.minus,
          width: 32,
          height: 32,
          size: TSizes.md,
          color: THelperFunctions.isDarkMode(context)
              ? TColors.white
              : TColors.black,
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? TColors.darkerGrey
              : TColors.light,
        ),
        const SizedBox(width: TSizes.spaceBwItems),
        Text(
          '2',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(width: TSizes.spaceBwItems),
        const TCircularIcon(
          icon: Iconsax.add,
          width: 32,
          height: 32,
          size: TSizes.md,
          color: TColors.white,
          backgroundColor: TColors.primary,
        ),
      ],
    );
  }
}
