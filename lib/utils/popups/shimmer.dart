import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TShimerEffect extends StatelessWidget {
  const TShimerEffect({
    Key? key,
    required this.width,
    required this.height,
    this.radius = 15,
    this.color,
  }) : super(key: key);
  final double width, height, radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Shimmer.fromColors(baseColor: isDark ?  TColors.primary.withAlpha(255) : TColors.secondry.withAlpha(255), highlightColor: isDark ? Colors.grey[600]! : Colors.grey[200]!, child: Container(width: width, height: height, decoration: BoxDecoration(color: color ?? (isDark ? Colors.grey[800]! : Colors.grey[300]!), borderRadius: BorderRadius.circular(radius))),);
  }
}