import "package:flutter/material.dart";
import "package:stem_shop/utils/constants/colors.dart";

class TCircularContianer extends StatelessWidget {
  const TCircularContianer({
    super.key,
     this.width=400,
     this.height=400,
     this.padding = 0,
     this.borderRadius = 400,
     this.backgroundColor = TColors.textwhite,
     this.child,

  });

  final double? width;
  final double? height;
  final double padding ;
  final double borderRadius ;
  final Color backgroundColor ;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
    
        color: TColors.textwhite.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}