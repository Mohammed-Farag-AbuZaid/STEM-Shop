import "package:flutter/material.dart";
import "package:stem_shop/utils/constants/colors.dart";

class TCircularContianer extends StatelessWidget {
  const TCircularContianer({
    super.key,
    this.width = 400,
    this.height = 400,
    this.padding = 0,
    this.borderRadius = 400,
    this.backgroundColor = TColors.textwhite,
    this.child,
    this.margin,
  });

  final double? width;
  final double? height;
  final double padding;
  final double borderRadius;
  final Color backgroundColor;
  final Widget? child;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,

      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(borderRadius)),
      child: child,
    );
  }
}
