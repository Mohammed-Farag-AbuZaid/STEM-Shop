import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:stem_shop/common/widgets/images/rounded_image.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TProductImageSlider extends StatefulWidget {
  const TProductImageSlider({super.key, required this.images});

  final List<String> images;

  @override
  State<TProductImageSlider> createState() => _TProductImageSliderState();
}

class _TProductImageSliderState extends State<TProductImageSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final images = widget.images.isNotEmpty ? widget.images : [TImages.tfLogo];

    return TCustomCurvedEdges(
      child: Container(
        color: isDark ? const Color.fromARGB(255, 11, 11, 11) : TColors.light,
        child: Stack(
          children: [
            /// Product Image Carousel
            SizedBox(
              height: 400,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 400,
                  viewportFraction: 1,
                  enlargeCenterPage: false,
                  onPageChanged: (index, _) =>
                      setState(() => _currentIndex = index),
                ),
                items: images.map((img) {
                  return Padding(
                    padding:
                        const EdgeInsets.all(TSizes.productImageRadius * 2),
                    child: TRoundedImage(imagePath: img),
                  );
                }).toList(),
              ),
            ),

            if (images.length > 1)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                    (index) => TCircularContianer(
                      width: 8,
                      height: 8,
                      borderRadius: 4,
                      backgroundColor: _currentIndex == index
                          ? TColors.primary
                          : Colors.grey,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ),
                ),
              ),

            /// AppBar
            TAppBar(showBackArrow: true, title: null),
          ],
        ),
      ),
    );
  }
}