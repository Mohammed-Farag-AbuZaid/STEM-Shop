import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/search_container.dart';
import 'package:stem_shop/common/widgets/layouts/grid_layout.dart';
import 'package:stem_shop/common/widgets/product/product_card_skeleton.dart';
import 'package:stem_shop/common/widgets/product/product_card_vertical.dart';
import 'package:stem_shop/common/widgets/texts/section_heading.dart';
import 'package:stem_shop/features/authentication/screens/home/home_appbar.dart';
import 'package:stem_shop/features/shop/controllers/products_controler.dart';
import 'package:stem_shop/features/shop/screens/all_products/all_products.dart';
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

                  /// -- Heading
                  TSectionHeading(
                    title: 'Popular Products',
                    onPressed: () => Get.to(() => AllProducts()),
                  ),
                  const SizedBox(height: TSizes.spaceBwItems),

                  Obx(() {
                    if (ProductController.instance.homeLoading.value) {
                      return TGridLayout(
                        itemCount: 4,
                        mainAxisExtent: 288,
                        itemBuilder: (_, __) => const TProductCardSkeleton(),
                      );
                    }

                    final products = ProductController.instance.homeProducts
                        .toList();
                    if (products.isEmpty) {
                      return const Center(
                        child: Text(
                          'No products available in your school yet.',
                        ),
                      );
                    }

                    return TGridLayout(
                      itemCount: products.length,
                      mainAxisExtent: 288,
                      itemBuilder: (_, index) =>
                          TProductCardVertical(product: products[index]),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
