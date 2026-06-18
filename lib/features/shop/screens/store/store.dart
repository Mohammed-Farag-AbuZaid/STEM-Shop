import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/appbar/tabbar.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/search_container.dart';
import 'package:stem_shop/common/widgets/product_cart/cart_menu_icon.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/shop/screens/store/category_tap.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';
import 'package:stem_shop/utils/popups/shimmer.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: TAppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Store', style: Theme.of(context).textTheme.headlineMedium),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Obx(() {
                  if (controller.profileLoading.value) {
                    return const TShimerEffect(width: 150, height: 20);
                  } else {
                    return Text(
                      controller.user.value.stemSchool,
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall!.apply(color: TColors.white),
                    );
                  }
                }),
              ),
            ],
          ),
          actions: [
            TCartCounterIcon(
              onPressed: () {},
              iconColor: TColors.primary,
              counterBgColor: Colors.black,
              counterTextColor: Colors.white,
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: THelperFunctions.isDarkMode(context)
                    ? Colors.black
                    : Colors.white,
                expandedHeight: 170,

                flexibleSpace: Padding(
                  padding: EdgeInsets.only(top: TSizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: TSizes.defaultSpace),
                      TSearchContainer(
                        text: 'Search products...',
                        onTap: () {},
                        showBackground: false,
                      ),
                    ],
                  ),
                ),
                bottom: TTabBar(
                  tabs: [
                    Tab(child: Text("Electronics")),
                    Tab(child: Text("Equipment")),
                    Tab(child: Text("Books")),
                    Tab(child: Text("Study Stuff")),
                    Tab(child: Text("Materials")),
                    Tab(child: Text("food")),
                    Tab(child: Text("sports")),
                    Tab(child: Text("routers")),
                    Tab(child: Text("others")),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              TCategoryShowcase(),
              TCategoryShowcase(),
              TCategoryShowcase(),
              TCategoryShowcase(),
              TCategoryShowcase(),
              TCategoryShowcase(),
              TCategoryShowcase(),
              TCategoryShowcase(),
              TCategoryShowcase(),
            ],
          ),
        ),
      ),
    );
  }
}
