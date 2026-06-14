import 'package:flutter/material.dart';

class TProductPriceText extends StatelessWidget {
  const TProductPriceText({
    super.key,
    this.currencySign = '\$',
    required this.price,
    this.maxLines = 1,
    this.isLarge = false,
    this.lineThrough = false,
  });

  final String currencySign, price;
  final int maxLines;
  final bool isLarge;
  final bool lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      currencySign + price,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: lineThrough
          ? Theme.of(context).textTheme.titleSmall!.copyWith(decoration: TextDecoration.lineThrough)
          : isLarge
              ? Theme.of(context).textTheme.headlineMedium
              : Theme.of(context).textTheme.titleLarge,
    );
  }
}
