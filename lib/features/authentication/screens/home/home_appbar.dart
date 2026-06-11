import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/product_cart/cart_menu_icon.dart';
import 'package:stem_shop/utils/constants/colors.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STEM 6th of October',
            style: Theme.of(
              context,
            ).textTheme.labelMedium!.apply(color: TColors.grey),
          ),
          Text(
            'Mohamed Farag',
            style: Theme.of(context).textTheme.headlineSmall!
                .apply(color: TColors.white),
          ),
        ],
      ),
      actions: [
        TCartCounterIcon(iconColor: TColors.white, onPressed: () {}),
      ],
    );
  }
}