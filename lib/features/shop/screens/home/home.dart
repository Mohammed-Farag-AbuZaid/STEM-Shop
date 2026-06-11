import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/search_container.dart';
import 'package:stem_shop/common/widgets/texts/section_heading.dart';
import 'package:stem_shop/features/authentication/screens/home/home_appbar.dart';
import 'package:stem_shop/features/shop/screens/home/widgets/home_categories.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  // AppBar
                  THomeAppBar(),
                  const SizedBox(height: TSizes.spaceBwSections),
                  // searchBar
                  TSearchContainer(text: "Saerch in Store"),
                  SizedBox(height: TSizes.spaceBwSections),
                  // -- categories
                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        // Heading
                        TSectionHeading(
                          title: "title categories",
                          showActionButton: false,
                          textColor: Colors.white,
                        ),
                        SizedBox(height: TSizes.spaceBwItems),

                        // Categories
                        THomeCategories(),
                      ],
                    ),
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
