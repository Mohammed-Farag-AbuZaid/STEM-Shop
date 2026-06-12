import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/search_container.dart';
import 'package:stem_shop/common/widgets/layouts/grid_layout.dart';
import 'package:stem_shop/common/widgets/product/product_card_vertical.dart';
import 'package:stem_shop/common/widgets/texts/section_heading.dart';
import 'package:stem_shop/features/authentication/screens/home/home_appbar.dart';
import 'package:stem_shop/features/shop/screens/home/widgets/home_categories.dart';
import 'package:stem_shop/features/shop/screens/home/widgets/promo_slider.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  THomeAppBar(),
                  SizedBox(height: TSizes.spaceBwSections),
                  TSearchContainer(text: "Search in Store", onTap: () {}),
                  SizedBox(height: TSizes.spaceBwSections),
                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TSectionHeading(
                          title: "Categories",
                          showActionButton: false,
                          textColor: Colors.white,
                        ),
                        SizedBox(height: TSizes.spaceBwItems),
                        THomeCategories(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  TPromoSlider(isDark: isDark),
                  const SizedBox(height: TSizes.spaceBwSections),
                  TSectionHeading(
                    title: 'Latest Products',
                    onPressed: () {},
                    buttonTitle: "See All",
                  ),
                  const SizedBox(height: TSizes.spaceBwItems),
                  TGridLayout(
                    itemCount: 10,
                    mainAxisExtent: 288,
                    itemBuilder: (_, index) => TProductCardVertical(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
