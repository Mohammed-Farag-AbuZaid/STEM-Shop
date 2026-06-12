import 'package:flutter/material.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/device/device_utility.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> tabs;

  const TTabBar({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: THelperFunctions.isDarkMode(context) ? Colors.black : Colors.white,
      child: TabBar(
      
        isScrollable: true,
        indicatorColor: TColors.primary,
        unselectedLabelColor: TColors.darkGrey,
        labelColor: THelperFunctions.isDarkMode(context) ? Colors.white : Colors.black,
        tabs: tabs,
      ),
    );
  }

  @override
  Size get preferredSize =>  Size.fromHeight(TDeviceUtils.getAppBarHeight());
}