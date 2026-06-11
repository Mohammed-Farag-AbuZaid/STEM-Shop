import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/utils/constants/colors.dart';

class TCartCounterIcon extends StatelessWidget {
  const TCartCounterIcon({
    super.key,
    required this.iconColor,
    required this.onPressed,
  });

  final Color? iconColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Iconsax.shopping_cart1,
            color: TColors.white,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '3',
                style: Theme.of(context).textTheme.labelLarge!
                    .apply(color: TColors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
