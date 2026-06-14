import 'package:flutter/material.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class TRoundedImage extends StatelessWidget {
  const TRoundedImage({
    super.key,
    required this.imagePath,
    this.borderRadius = TSizes.md,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.applyImageRadius = true,
    this.border,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.backgroundColor = TColors.light, 
  });

  final String imagePath;
  final double borderRadius;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final bool applyImageRadius;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
          color: backgroundColor,
        ),
        padding: padding,
        child: ClipRRect(
          borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius) : BorderRadius.zero,
          child: Image(
            image: isNetworkImage ? NetworkImage(imagePath) : AssetImage(imagePath) as ImageProvider,
            fit: fit,
            width: width,
            height: height,
          ),
        ),
      ),
    );
  }
}
