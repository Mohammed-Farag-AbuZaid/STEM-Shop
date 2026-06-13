import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            TCircularContianer(
              borderRadius: TSizes.sm,
              backgroundColor: TColors.secondry.withValues(alpha: 0.8),
              padding: EdgeInsets.symmetric(
                horizontal: TSizes.sm,
                vertical: TSizes.xs,
              ),
              child: Text(
                '20%',
                style: Theme.of(context).textTheme.labelLarge!.apply(
                  color: isDark ? TColors.secondry : Colors.black,
                ),
              ),
            ),
            SizedBox(width: TSizes.sm),
            Stack(
              children: [
                Text(
                  '\$100 ',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isDark ? TColors.grey : TColors.darkGrey,
                ),),
                Positioned(
                  bottom: 6,
                  right: 3,
                  child: Container(
                    height: 2,
                    width: 25,
                    color: Colors.red
                  ),
                ),
              ]
              ),
            
            SizedBox(width: TSizes.sm),
            Text('\$80', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),

        IconButton(onPressed: () {}, icon: Icon(Icons.share)),
      ],
    );
  }
}
