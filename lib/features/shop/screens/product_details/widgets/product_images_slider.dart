import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:stem_shop/common/widgets/images/rounded_image.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TProductImageSlider extends StatelessWidget {
  const TProductImageSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return TCustomCurvedEdges(
      child: Container(
        color: isDark ?const Color.fromARGB(255, 11, 11, 11): TColors.light,
        child: Stack(
          children: [
            /// Product Image
            SizedBox(
              height: 400,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(
                    TSizes.productImageRadius * 2,
                  ),
                  child: TRoundedImage(imagePath: TImages.tfLogo)
                ),
              ),
            ),
    
            /// image slider
            Positioned(
              right: 0,
              bottom: 30,
              left: TSizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, _) => const SizedBox(width: TSizes.spaceBwItems),
                  itemBuilder: (_, index) => TRoundedImage(
                    imagePath: TImages.emailSentImage,
                    width: 80,
                    height: 80,
                    backgroundColor: isDark ? TColors.dark : TColors.white,
                    border: Border.all(color: TColors.primary),
                    padding: const EdgeInsets.all(TSizes.sm),
                  ),
                ),
              ),
            ),
            /// AppBar
            TAppBar(
              showBackArrow: true,
              title: null,
            
            ),
          ],
        ),
      ),
    );
  }
}
