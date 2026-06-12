import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/appbar/tabbar.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/search_container.dart';
import 'package:stem_shop/common/widgets/product_cart/cart_menu_icon.dart';
import 'package:stem_shop/features/shop/screens/store/category_tap.dart';
import 'package:stem_shop/features/shop/screens/store/sub_category_card.dart';
import 'package:stem_shop/features/shop/screens/store/sub_category_showcase.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: Text(
                  'STEM 6th of October',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
          actions: [TCartCounterIcon(onPressed: () {})],
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

