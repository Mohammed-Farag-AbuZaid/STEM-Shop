import 'package:flutter/material.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/popups/shimmer.dart';

class TCategoryShimmer extends StatelessWidget {
  const TCategoryShimmer({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: itemCount,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, _) => const SizedBox(width: TSizes.spaceBwItems),
        itemBuilder: (_, _) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
              TShimerEffect(width: 55, height: 55, radius: 55),
              SizedBox(height: TSizes.spaceBwItems / 2),

              /// Text
              TShimerEffect(width: 55, height: 8),
            ],
          ); // Column
        },
      ),
    );
  }
}
