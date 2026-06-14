import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/common/widgets/image_text_widgets/vertical_image_text.dart';
import 'package:stem_shop/features/shop/screens/sub_category/sub_categories.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';

class THomeCategories extends StatelessWidget {
  const THomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ['Sensors', 'Motors', 'Electro...', 'Contro...', 'Books', 'Kits'];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return TVerticalImageText(
            image: TImages.lightDigital, 
            title: categories[index],
            onTap: () => Get.to(() => const SubCategoriesScreen()), 
          );
        },
      ),
    );
  }
}
