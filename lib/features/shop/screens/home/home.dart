import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:stem_shop/features/authentication/screens/home/home_appbar.dart';
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
            TPrimaryHeaderContainer(child: Column(children: [THomeAppBar()])),
            Padding(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: TPromoSlider(isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}

