import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/features/personalization/screens/seetings/settings.dart';
import 'package:stem_shop/features/shop/screens/comming_soon/comming_soon.dart';
import 'package:stem_shop/features/shop/screens/home/home.dart';
import 'package:stem_shop/features/shop/screens/product_details/screens/product_details.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/features/shop/screens/store/store.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.black : Colors.white,
          indicatorColor: darkMode ? TColors.white.withValues(alpha: 0.1) : TColors.black.withValues(alpha: 0.1),
          destinations: [
            const NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            const NavigationDestination(icon: Icon(Iconsax.bag_tick), label: 'Buy'),
            NavigationDestination(
              icon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: darkMode ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.add,
                  color: darkMode ? Colors.black : Colors.white,
                  size: 20,
                ),
              ),
              label: 'Sell',
            ),
            const NavigationDestination(icon: Icon(Iconsax.card_send), label: 'Store'),
            const NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const ProductDetailsScreen(),
    Container(color: Colors.green),
    const ComingSoonScreen(),
    const SettingsScreen(),
  ];
}
