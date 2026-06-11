import 'package:flutter/material.dart';
import 'package:stem_shop/common/widgets/image_text_widgets/vertical_image_text.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';

class Category {
  final String image;
  final String title;

  const Category({
    required this.image,
    required this.title,
  });
}

class THomeCategories extends StatelessWidget {
  const THomeCategories({super.key});

  final List<Category> categories = const [
    Category(image: TImages.google, title: 'Sensors'),
    Category(image: TImages.google, title: 'Motors'),
    Category(image: TImages.google, title: 'Electronics'),
    Category(image: TImages.google, title: 'Controllers'),
    Category(image: TImages.google, title: 'Books'),
    Category(image: TImages.google, title: 'Kits'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = categories[index];

          return SizedBox(
            width: 70,
            child: TVerticalImageText(
              image: category.image,
              title: category.title,
              onTap: () {
                
              },
            ),
          );
        },
      ),
    );
  }
}