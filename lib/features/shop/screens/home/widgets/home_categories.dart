import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/common/widgets/image_text_widgets/vertical_image_text.dart';
import 'package:stem_shop/features/shop/controllers/categories_controller.dart';
import 'package:stem_shop/features/shop/screens/sub_category/sub_categories.dart';
import 'package:stem_shop/utils/popups/category_shimmer.dart';

class THomeCategories extends StatelessWidget {
  const THomeCategories({super.key});
  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoriesController());

    return Obx(() {
      if (categoryController.isLoading.value) return const TCategoryShimmer();
      if (categoryController.featuredCategories.isEmpty){
        return Center(child: Text('No Data Found', style: Theme.of(context).textTheme.bodyMedium! .apply(color: Colors.white)));
      }
      return SizedBox(
        height: 110,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: categoryController.featuredCategories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final Category = categoryController.featuredCategories[index];
            return TVerticalImageText(
              image: Category.image,
              title: Category.name,
              onTap: () => Get.to(() => const SubCategoriesScreen()),
            );
          },
        ),
      );
    });
  }
}
