import 'package:flutter/material.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class ProductMetaData extends StatelessWidget {
  const ProductMetaData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// price and sale price
        SizedBox(height: TSizes.spaceBwItems),
        Row(children: [
          
        ],),
        
        Text(
          'Product Name',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: TSizes.spaceBwItems),
        Text(
          '5 in stock',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.green,
              ),
        ),
        SizedBox(height: TSizes.spaceBwItems),
        Text(
          'Seller: Seller Name',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        
      ],
    );
  }
}
