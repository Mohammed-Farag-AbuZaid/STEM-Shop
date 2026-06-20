import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/features/shop/controllers/categories_controller.dart';
import 'package:stem_shop/features/shop/models/category_model.dart';
import 'package:stem_shop/features/shop/screens/store/sub_category_showcase.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoriesController.instance;

    return Scaffold(
      appBar: TAppBar(
        title: Text(category.name),
        showBackArrow: true,
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: controller.getSubCategories(category.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No subcategories found'));
          }

          final subCategories = snapshot.data!;

          // ListView.builder renders only visible items — prevents all
          // subcategories from loading their Firestore queries at once
          return ListView.builder(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            itemCount: subCategories.length,
            itemBuilder: (context, index) {
              return TSubCategoryShowcase(
                subCategory: subCategories[index],
              );
            },
          );
        },
      ),
    );
  }
}