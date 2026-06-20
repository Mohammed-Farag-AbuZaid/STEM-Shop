import 'package:flutter/material.dart';
import 'package:stem_shop/features/shop/controllers/categories_controller.dart';
import 'package:stem_shop/features/shop/models/category_model.dart';
import 'package:stem_shop/features/shop/screens/store/sub_category_showcase.dart';

class TCategoryShowcase extends StatelessWidget {
  const TCategoryShowcase({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoriesController.instance;

    return FutureBuilder<List<CategoryModel>>(
      future: controller.getSubCategories(category.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No subcategories found'));
        }

        final subCategories = snapshot.data!;

        return ListView.builder(
          itemCount:
              subCategories.length + 1, 
          itemBuilder: (context, index) {
            if (index < subCategories.length) {
              return TSubCategoryShowcase(subCategory: subCategories[index]);
            }
            // Last item: suggested products section
           
          },
        );
      },
    );
  }
}
