import 'package:flutter/material.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/popups/shimmer.dart';

class RequestCardSkeleton extends StatelessWidget {
  const RequestCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TSizes.md),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TShimerEffect(width: 28, height: 28),
              SizedBox(width: 8),
              TShimerEffect(width: 100, height: 12),
            ],
          ),
          SizedBox(height: 10),
          TShimerEffect(width: 160, height: 14),
          SizedBox(height: 6),
          TShimerEffect(width: 200, height: 12),
        ],
      ),
    );
  }
}